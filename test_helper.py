"""
"""
from utils.event_injector import EventInjector
from utils.zenoss_client import ZenossClient

import json
import pymysql
import time

from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains

class ZenossTestHelper(object):

	MAX_REFRESH_WAIT_TIME = 5

	def __init__(self):
		self.config = {}
		self.ui_helper = ZenossUserInterfaceHelper()
		self.event_helper = ZenossEventsHelper()
		self.index_interval = -1

	def init(self):
		""" """
		with open("./config.json") as json_file:
			self.config = json.load(json_file)
			self.ui_helper.init(self.config)
			self.event_helper.init(self.config)

	def shutdown(self):
		#print ("Press a key to continue")
		#raw_input()
		self.ui_helper.shutdown()
		self.event_helper.shutdown()

	def load_sample_events(self):
		""" """
		events = []
		with open("./features/events.json") as json_file:
			json_events = json.load(json_file)
			events = json_events["events"]
		return events

	def wait_for_ui_to_update(self, last_updated = None):
		deadline = time.time() + self.MAX_REFRESH_WAIT_TIME
		if last_updated is None:
			last_updated = self.get_events_grid_last_updated()
		while time.time() < deadline:
			time.sleep(0.5)
			if self.get_events_grid_last_updated() != last_updated:
				time.sleep(0.1)
				break

	#---------------------------------------------------------
	#                    UI related calls
	#---------------------------------------------------------

	def login_zenoss(self):
		return self.ui_helper.login_zenoss()

	def go_to_event_console(self, archive=False):
		return self.ui_helper.go_to_event_console(archive)

	def reset_event_console(self):
		return self.ui_helper.reset_event_console()

	def display_fields(self, fields):
		return self.ui_helper.display_fields(fields)

	def set_indexing_freq(self, seconds):
		try:
			self.ui_helper.set_indexing_freq(seconds)
		except NoSuchElementException:
			time.sleep(0.5)
			self.ui_helper.set_indexing_freq(seconds)

	def refresh_event_console(self):
		self.ui_helper.refresh_event_console()

	def set_filter(self, field_name, value):
		self.ui_helper.set_filter(field_name, value)

	def clear_filter(self, field_name):
		self.ui_helper.clear_filter(field_name)

	def get_events_grid_last_updated(self):
		return self.ui_helper.get_events_grid_last_updated()

	def get_uuids_displayed_in_ui(self):
		return self.ui_helper.get_uuids_displayed_in_ui()

	def is_field_sortable(self, field):
		return self.ui_helper.is_field_sortable(field)

	def sort_field(self, field, asc):
		return self.ui_helper.sort_field(field, asc)

	def is_event_above(self, above_uuid, below_uuid):
		return self.ui_helper.is_event_above(above_uuid, below_uuid)

	#---------------------------------------------------------
	#                  Event related calls
	#---------------------------------------------------------

	def create_event(self, event_type, event):
		return self.event_helper.create_event(event_type, event)

	def delete_event(self, uuid, archive):
		self.event_helper.delete_event(uuid, archive)

	def wait_until_events_are_indexed(self, uuids, archive):
		start = time.time()
		indexed = True
		while not self.event_helper.are_uuids_indexed(uuids, archive):
			if time.time() - start >= 90: # we wait 90 seconds tops
				indexed = False
				break
			else:
				time.sleep(1)
		return indexed

class ZenossEventsHelper(object):

	def __init__(self):
		self.config = {}
		self.zenoss_client = ZenossClient()

	def init(self, config):
		""" """
		self.config = config
		self.conn = pymysql.connect(
		    host=self.config.get('db-host', 'localhost'),
            port=self.config.get('db-port', '13306'),
            user=self.config.get('db-user', 'zenoss'),
            passwd=self.config.get('db-password', 'zenoss'),
            db=self.config.get('db-name', 'zenoss_zep'))
		self.event_injector = EventInjector(self.conn)
		self.zenoss_client.init(self.config)

	def shutdown(self):
		self.zenoss_client.shutdown()
		if self.conn:
			self.conn.close()

	def create_event(self, event, archive):
		return self.event_injector.inject_event(event, archive)

	def delete_event(self, uuid, archive):
		self.event_injector.delete_event(uuid, archive)

	def are_uuids_indexed(self, uuids, archive):
		event_ids = [ "{0}".format(uuid) for uuid in uuids ]
		data = self.zenoss_client.send_event_filter_request({'evid': event_ids}, archive)
		return data['totalCount'] == len(event_ids)

class ZenossUserInterfaceHelper(object):

	field_name_to_filter_id = {
		"Count" : "count",
		"Last Seen" : "lastTime",
		"First Seen" : "firstTime",
		"Summary" : "summary",
		"Event Class" : "eventClass",
		"Component" : "component",
		"Resource" : "device",
		"Severity" : "severity",
		"Event State" : "eventState",
		"Device Class" : "DeviceClass",
		"Owner" : "ownerid",
		"Agent" : "agent",
		"Collector" : "monitor",
		"Event Key" : "eventKey",
		"Event Class Key" : "eventClassKey",
		"Event Group" : "eventGroup",
		"Device Priority" : "DevicePriority",
		"Event Class Mapping" : "eventClassMapping",
		"Event ID" : "evid",
		"Fingerprint" : "dedupid",
		"Groups" : "DeviceGroups",
		"IP Address" : "ipAddress",
		"Location" : "Location",
		"Message" : "message",
		"Production State" : "prodState",
		"State Change" : "stateChange",
		"Systems" : "Systems",
	}

	def __init__(self):
		self.config = {}
		self.browser = None

	def init(self, config):
		""" """
		self.config = config
		self.browser = webdriver.Firefox()

	def shutdown(self):
		self.browser.quit()

	def login_zenoss(self):
		""" """
		# go to the event console bc the dashboard has that annoying google maps popup
		#
		success = False
		if "Event" in self.browser.title: # In case we already are logged in
			success =  True
		else:
			zenoss_url = "{0}/{1}".format(self.config.get("zenoss_url"), "/zport/dmd/Events/evconsole")
			self.browser.get(zenoss_url)
			if "Login" in self.browser.title:
				username = self.browser.find_element_by_name("__ac_name")
				password = self.browser.find_element_by_name("__ac_password")
				username.send_keys(self.config.get("zenoss_user"))
				password.send_keys(self.config.get("zenoss_password"))
				self.browser.find_element_by_id("loginButton").click()
				if "Events" in self.browser.title: # In case we already are logged in
					success =  True
		return success

	def go_to_event_console(self, archive=False):
		""" """
		if (archive and "Event Archive" in self.browser.title) or \
		   (not archive and "Events" in self.browser.title):
		   return True

		console = "evconsole" if not archive else "evhistory"
		url = "{0}/{1}/{2}".format(self.config.get("zenoss_url"), "/zport/dmd/Events/", console)
		self.browser.get(url)
		if archive:
			return "Event Archive" in self.browser.title
		else:
			return "Events" in self.browser.title

	def display_fields(self, fields):
		""" Makes sure that the fields passed as a parameter are shown in the event console """
		displayed = False
		configure_btn = self.browser.find_element_by_id("configure-button")
		configure_btn.click()
		adjust_columns_cmp = self.browser.find_elements_by_id("adjust_columns_item_selector-textEl")
		if adjust_columns_cmp:
			adjust_columns_cmp[0].click()
			popup = self.browser.find_elements_by_id("events_column_config_dialog")[0]
			lists = popup.find_elements_by_xpath(".//div[@class='x-boundlist-list-ct']")
			available = lists[0]
			selected = lists[1]
			if available.location['x'] >  selected.location['x']:
				available, selected = selected, available

			move_to_top_btn = None
			add_to_selected_btn = None
			items = popup.find_elements_by_xpath(".//button")
			for item in items:
				if "Move to Top" in item.get_attribute("data-qtip"):
					move_to_top_btn = item
				elif "Add to Selected" in item.get_attribute("data-qtip"):
					add_to_selected_btn = item
				if move_to_top_btn and add_to_selected_btn:
					break

			# Move items from available to selected
			for field in fields:
				try:
					item = available.find_element_by_xpath(".//li[@class='x-boundlist-item' and text()='{0}']".format(field))
					item.click()
					add_to_selected_btn.click()
					#actionChains = ActionChains(self.browser)
					#actionChains.double_click(item).perform()
				except NoSuchElementException:
					pass 

			# Place 'fields' top on the list					
			if move_to_top_btn:
				for field in reversed(fields):
					try:
						item = selected.find_elements_by_xpath(".//li[@class='x-boundlist-item' and text()='{0}']".format(field))[0]
						while not item.is_displayed():
							selected.send_keys(Keys.ARROW_DOWN)
						item.click()
						move_to_top_btn.click()
					except (IndexError, NoSuchElementException):
						pass

			## Submit button
			#
			submit_btn = popup.find_elements_by_xpath(".//button[*[text()='Submit']]")
			if submit_btn:
				submit_btn = submit_btn[0].click()
			displayed = True

		return displayed

	def set_indexing_freq(self, seconds):
		""" """
		url = "{0}/{1}".format(self.config.get("zenoss_url"), "/zport/dmd/eventConfig")
		self.browser.get(url)
		summary_setting = self.browser.find_element_by_id("index_summary_interval_milliseconds")
		summary_setting.find_element_by_xpath(".//input").clear()
		summary_setting.find_element_by_xpath(".//input").send_keys("{0}".format(seconds*1000))
		archive_setting = self.browser.find_element_by_id("index_archive_interval_milliseconds")
		archive_setting.find_element_by_xpath(".//input").clear()
		archive_setting.find_element_by_xpath(".//input").send_keys("{0}".format(seconds*1000))

		# Click save button
		self.browser.find_element_by_xpath(".//button[*[text()='Save']]").click()

	def refresh_event_console(self):
		self.browser.find_element_by_id("refresh-button").click()
		

	def _get_filter(self, field_name):
		filters_container = self.browser.find_element_by_id("events_griddocked-filter")
		field_id = "events_grid-filter-{0}".format(self.field_name_to_filter_id[field_name])
		return filters_container.find_element_by_id(field_id).find_element_by_xpath(".//input")

	def set_filter(self, field_name, value):
		self._get_filter(field_name).send_keys(value)

	def clear_filter(self, field_name):
		self._get_filter(field_name).clear()

	def reset_event_console(self):
		configure_btn = self.browser.find_element_by_id("configure-button")
		configure_btn.click()
		restore_defatuls_btn = self.browser.find_elements_by_xpath(".//*[@class='x-menu-item-text' and text()='Restore defaults']")[0]
		restore_defatuls_btn.click()
		popup = self.browser.find_elements_by_xpath("//div[contains(@class, 'x-window ') and contains(@class, 'x-closable') ]")[0]
		popup.find_elements_by_xpath(".//span[text()='OK']")[0].click()

	def get_uuids_displayed_in_ui(self):
		events_grid = self.browser.find_element_by_id("events_grid")
		uuids = []
		try:
			uuids =[ row.text for row in events_grid.find_elements_by_xpath(".//td[contains(@class, 'x-grid-cell-evid')]") ]
		except NoSuchElementException:
			pass
		return uuids

	def _get_sort_field_btn(self, field, asc):
		# header_div
		header_text = self.browser.find_element_by_xpath("//span[@class='x-column-header-text' and contains(text(), '{0}')]".format(field))
		header_text.click()
		#time.sleep(0.1)
		header_div = header_text.find_element_by_xpath(".//../div")
		if not header_div.is_displayed():
			header_text.click()
			time.sleep(0.2)
			header_div = header_text.find_element_by_xpath(".//../div")
		#time.sleep(0.1)
		header_div.click()
		if asc:
			order_by_btn = self.browser.find_element_by_xpath(".//*[contains(@class, 'x-hmenu-sort-asc')]")
		else:
			order_by_btn = self.browser.find_element_by_xpath(".//*[contains(@class, 'x-hmenu-sort-desc')]")
		return order_by_btn

	def is_field_sortable(self, field):
		order_by_btn = self._get_sort_field_btn(field, True)
		return ('x-menu-item-disabled' not in order_by_btn.get_attribute('class'))

	def sort_field(self, field, asc):
		order_by_btn = self._get_sort_field_btn(field, asc)
		order_by_btn.click()

	def is_event_above(self, above_uuid, below_uuid):
		events_grid = self.browser.find_element_by_id("events_grid")
		condition_met = False
		above_row_y_pos = None
		below_row_y_pos = None
		for row in events_grid.find_elements_by_xpath(".//td[contains(@class, 'x-grid-cell-evid')]"):
			if above_uuid == row.text:
				above_row_y_pos = row.location['y']
			elif below_uuid == row.text:
				below_row_y_pos = row.location['y']
			if above_row_y_pos and below_row_y_pos:
				break

		if above_row_y_pos and below_row_y_pos and above_row_y_pos < below_row_y_pos:
			condition_met = True

		return condition_met

	def get_events_grid_last_updated(self):
		return self.browser.find_element_by_id("lastupdated").text
