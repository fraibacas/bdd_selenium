
from behave import *
import time

@given('I am logged in Zenoss')
def step_impl(context):
	login = context.zenoss_test_helper.login_zenoss()
	assert login is True 

@given('the indexing interval is set to "{seconds}" seconds')
def step_impl(context, seconds):
	if context.zenoss_test_helper.index_interval != float(seconds):
		seconds = float(seconds)
		context.zenoss_test_helper.set_indexing_freq(seconds)
		context.zenoss_test_helper.index_interval = seconds

@given('the sample events have been loaded and indexed')
def step_impl(context):
	if context.created_events:
		return True
	# Create the sample events in both summary and archive
	events = context.zenoss_test_helper.load_sample_events()
	uuids = []

	# Lets create the events
	for event in events:
		event_id = event['event_id']
		context.event_data[event_id] = event
		uuid = context.zenoss_test_helper.create_event(event, context.archive)
		context.created_events[event_id] = uuid
		uuids.append(uuid)

	# Lets wait until events are indexed
	indexed = context.zenoss_test_helper.wait_until_events_are_indexed(uuids, context.archive)
	assert indexed is True

@given('I am in the event console')
def step_impl(context):
	assert context.zenoss_test_helper.go_to_event_console(context.archive) is True

@given('I click on "Configure -> Restore defaults"')
def step_impl(context):
	context.zenoss_test_helper.reset_event_console()
	time.sleep(0.2) # Let the UI reconfigure

@given('the "{field}" and "Event ID" fields are visible')
def step_impl(context, field):
	fields = [ field ]
	if field != "Event ID":
		fields.append("Event ID")
	displayed = context.zenoss_test_helper.display_fields(fields)
	assert displayed is True

@when('I filter for the loaded "{event_id}" event')
def step_impl(context, event_id):
	field = context.current_step_data["field"]
	uuid = context.created_events[event_id]
	context.current_events.append(uuid)
	if field != "Event ID":
		context.zenoss_test_helper.set_filter("Event ID", uuid)
		context.zenoss_test_helper.wait_for_ui_to_update()

@when('I type "{event_filter}" as filter for the "{field}" field in the Zenoss UI')
def step_impl(context, event_filter, field):
	if field!="Event ID" : # in case we are testing this field
		context.zenoss_test_helper.set_filter(field, event_filter)
	else:
		event_uuid = context.current_events[0]
		# We do not use the passed value since the event uuid is not known until we
		# create the event
		uuid_filter = event_uuid
		if "Partial string search from beginning" in context.scenario.name:
			uuid_filter = event_uuid[:5]
		elif "Partial string search not from beginning" in context.scenario.name:
			uuid_filter = event_uuid[2:6]
		elif "String search with wildcard '*'" in context.scenario.name:
			uuid_filter = "{0}{1}{2}".format(event_uuid[:2] , '*', event_uuid[6:])
		context.zenoss_test_helper.set_filter("Event ID", uuid_filter)

	context.zenoss_test_helper.wait_for_ui_to_update()

@then('I can see the "{event_id}" event')
def step_impl(context, event_id):
	""" """
	uuid = context.created_events[event_id]
	uuids = context.zenoss_test_helper.get_uuids_displayed_in_ui()
	assert uuid in uuids

@step('I use the Summary field to filter only the relevant events')
def step_impl(context):
	""" """
	# We dont do anything. We will add the filter to summary later
	context.zenoss_test_helper.clear_filter("Summary")
	context.zenoss_test_helper.set_filter("Summary", "zenoss_test")
	context.zenoss_test_helper.wait_for_ui_to_update()

#=======================================
#   Specific steps for OR scenario
#=======================================

@when('I type the following OR filter "{or_filter}" for the "{field}" field in the Zenoss UI')
def step_impl(context, or_filter, field):
	if field == "Event ID":
		# replace the dummy event_ids from the scenario for the real ones
		event_id_1 = context.current_step_data["event_id_1"]
		event_id_2 = context.current_step_data["event_id_2"]
		uuid_1 = context.created_events[event_id_1]
		uuid_2 = context.created_events[event_id_2]
		context.zenoss_test_helper.set_filter(field, "{0} || {1}".format(uuid_1, uuid_2))
	else:
		if field == "Summary":
			context.zenoss_test_helper.set_filter(field, " || {0}".format(or_filter) )  # we previously set a common filter in Summary
		else:
			context.zenoss_test_helper.set_filter(field, or_filter)

	context.zenoss_test_helper.wait_for_ui_to_update()

@then('I can see both "{event_id_1}" and "{event_id_2}" events')
def step_impl(context, event_id_1, event_id_2):
	uuid1 = context.created_events[event_id_1]
	uuid2 = context.created_events[event_id_2]
	uuids = context.zenoss_test_helper.get_uuids_displayed_in_ui()
	assert uuid1 in uuids and uuid2 in uuids

#=======================================
#   Specific steps for NOT scenario
#=======================================

@step('I clear the filter for "{field}" field')
def step_impl(context, field):
	context.zenoss_test_helper.clear_filter(field)

@when('I type the following NOT filter "{not_filter}" for the "{field}" field in the Zenoss UI')
def step_impl(context, not_filter, field):

	# We only display the events we are interested in
	#
	#if context.zenoss_test_helper.check_field_value("Summary", )
	context.zenoss_test_helper.clear_filter("Summary")
	context.zenoss_test_helper.set_filter("Summary", "zenoss_test ")

	if field == "Event ID":
		event_id_1 = context.current_step_data["event_id_1"]
		event_id_2 = context.current_step_data["event_id_2"]
		value2 = context.current_step_data["value_2"]
		uuid = context.created_events[event_id_1]
		if value2 in not_filter:
			uuid = context.created_events[event_id_2]
		context.zenoss_test_helper.set_filter(field, "!!{0}".format(uuid))
	else:
		if field == "Summary":
			context.zenoss_test_helper.set_filter(field, " {0}".format(not_filter) )  # we previously set a common filter in Summary
		else:
			context.zenoss_test_helper.set_filter(field, not_filter)

	context.zenoss_test_helper.wait_for_ui_to_update()

@then('I can not see "{not_found_id}" and I can see "{found_id}"')
def step_impl(context, not_found_id, found_id):
	not_found_uuid = context.created_events[not_found_id]
	found_uuid = context.created_events[found_id]

	uuids = context.zenoss_test_helper.get_uuids_displayed_in_ui()
	assert found_uuid in uuids and not_found_uuid not in uuids

#=======================================
#   Specific steps for SORT scenario
#=======================================

@when('I sort "{field}" in "{order}" order')
def step_impl(context, field, order):
	asc = True if order=="ascending" else False
	last_updated = context.zenoss_test_helper.get_events_grid_last_updated()
	context.zenoss_test_helper.sort_field(field, asc)
	context.zenoss_test_helper.wait_for_ui_to_update(last_updated)

@then('I see "{event_above}" above "{event_below}"')
def step_impl(context, event_above, event_below):
	above_uuid = context.created_events[event_above]
	below_uuid = context.created_events[event_below]
	assert context.zenoss_test_helper.is_event_above(above_uuid, below_uuid) is True


def _get_uuids_from_event_ids(context, event_ids):
	"""
	event_ids is a string containing a list of event_ids separated by commas
	"""
	uuids = []
	if event_ids != '""':
		for ev_id in event_ids.split(','):
			event_id = ev_id.strip()
			uuid = context.created_events[event_id]
			uuids.append(uuid)
	return uuids

#===========================================
#   Specific steps for IP Address scenario
#===========================================

@given('the following events have been created and indexed')
def step_impl(context):
	# this has already tested in @given('the sample events have been loaded and indexed')
	pass

@then('I see these events "{found_events}"')
def step_impl(context, found_events):
	""" """
	found_uuids = set(_get_uuids_from_event_ids(context, found_events))
	ui_uuids = set(context.zenoss_test_helper.get_uuids_displayed_in_ui())

	assert len(found_uuids - ui_uuids)==0

@then('I can not see these events "{not_found_events}"')
def step_impl(context, not_found_events):
	""" """
	not_found_uuids = set(_get_uuids_from_event_ids(context, not_found_events))
	ui_uuids = set(context.zenoss_test_helper.get_uuids_displayed_in_ui())

	assert len(not_found_uuids - ui_uuids)==len(not_found_uuids)
