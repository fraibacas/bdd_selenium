
Feature: Search for events using Zenoss UI filters
	I wish to use filters to search for active and archived events in Zenoss

	Background:
		Given I am logged in Zenoss
		and the indexing interval is set to "0.5" seconds
		and the sample events have been loaded and indexed
		  # Sample event are loaded from file events.json

	Scenario Outline: Text Filters

		Given I am in the event console
		and I click on "Configure -> Restore defaults"
		and the "<FIELD>" and "Event ID" fields are visible
		when I filter for the loaded "<EVENT_ID>" event
		and I type "<FILTER>" as filter for the "<FIELD>" field in the Zenoss UI
		then I can see the "<EVENT_ID>" event

		Examples: Partial string search from beginning
			###
			# Search for a string typing just the first n characters
			# Example: filter 'dev' would match 'device', 'devices', etc
			###
			|      EVENT_ID     |      FIELD         |       VALUE                                    |  FILTER   |
			|  evt_text_filters |   Component        |  test_component                                |  tes      |
			|  evt_text_filters |   Device Class     |  /Grandparent/Parent/Child                     |  grand    |
			|  evt_text_filters |   Device Class     |  /Grandparent/Parent/Child                     |  par      |
			|  evt_text_filters |   Device Class     |  /Grandparent/Parent/Child                     |  chil     |
			|  evt_text_filters |   Device Class     |  /Grandparent/Parent/Child                     |  /grand   |
			|  evt_text_filters |   Event Class      |  /Grandparent/Parent/Child                     |  grand    |
			|  evt_text_filters |   Event Class      |  /Grandparent/Parent/Child                     |  par      |
			|  evt_text_filters |   Event Class      |  /Grandparent/Parent/Child                     |  chil     |
			|  evt_text_filters |   Event Class      |  /Grandparent/Parent/Child                     |  /grand   |
			|  evt_text_filters |   IP Address       |  128.10.10.1                                   |  12       |
			|  evt_text_filters |   Resource         |  test_device                                   |  test     |
			|  evt_text_filters |   Summary          |  The quick brown fox jumps over the lazy dog   |  qui      |
			|  evt_text_filters |   Summary          |  The quick brown fox jumps over the lazy dog   |  bro      |
			|  evt_text_filters |   Summary          |  The quick brown fox jumps over the lazy dog   |  jum      |
			|  evt_text_filters |   Agent            |  zentest                                       |  zent     |
			|  evt_text_filters |   Collector        |  usa_collector1                                |  usa_     |
			|  evt_text_filters |   Event Class Key  |  myeventclasskey                               |  myev     |
			|  evt_text_filters |   Event Group      |  thisismygroup                                 |  thisi    |
			|  evt_text_filters |   Event ID         |  whatever                                      |  what     |
			|  evt_text_filters |   Event Key        |  randomEventKey                                |  randomE  |
			|  evt_text_filters |   Fingerprint      |  my_index_fingerprint                          |  my_      |
			|  evt_text_filters |   Groups           |  /Group/Subgroup                               |  gro      |
			|  evt_text_filters |   Groups           |  /Group/Subgroup                               |  sub      |
			|  evt_text_filters |   Groups           |  /Group/Subgroup                               |  /gro     |
			|  evt_text_filters |   Location         |  /UnitedStates/Austin                          |  uni      |
			|  evt_text_filters |   Location         |  /UnitedStates/Austin                          |  aus      |
			|  evt_text_filters |   Location         |  /UnitedStates/Austin                          |  /unit    |
			|  evt_text_filters |   Message          |  The quick brown fox jumps over the lazy dog   |  qui      |
			|  evt_text_filters |   Message          |  The quick brown fox jumps over the lazy dog   |  bro      |
			|  evt_text_filters |   Message          |  The quick brown fox jumps over the lazy dog   |  jum      |
			|  evt_text_filters |   Owner            |  name.surname                                  |  nam      |
			|  evt_text_filters |   Systems          |  /Systems/hello                                |  sys      |
			|  evt_text_filters |   Systems          |  /Systems/hello                                |  hel      |
			|  evt_text_filters |   Systems          |  /Systems/hello                                |  /sys     |



		Examples: Partial string search not from beginning
			###
			# Search for a string typing a subset of the string characters ommitting the first n chars
			# Example: filter 'evi' should match 'device', 'devices', etc
			###
			|      EVENT_ID     |   FIELD           |       VALUE                                    |  FILTER   |
			|  evt_text_filters |  Component        |  test_component                                |  ompo     |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  and      |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  ent      |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  hil      |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  and      |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  ent      |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  ild      |
			|  evt_text_filters |  IP Address       |  128.10.10.1                                   |  28       |
			|  evt_text_filters |  Resource         |  test_device                                   |  t_dev    |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  ick      |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  own      |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  mps      |
			|  evt_text_filters |  Agent            |  zentest                                       |  ntes     |
			|  evt_text_filters |  Collector        |  usa_collector1                                |  colle    |
			|  evt_text_filters |  Event Class Key  |  myeventclasskey                               |  class    |
			|  evt_text_filters |  Event Group      |  thisismygroup                                 |  ismy     |
			|  evt_text_filters |  Event ID         |  whatever                                      |  teve     |
			|  evt_text_filters |  Event Key        |  randomEventKey                                |  omev     |
			|  evt_text_filters |  Fingerprint      |  my_index_fingerprint                          |  finger   |
			|  evt_text_filters |  Groups           |  /Group/Subgroup                               |  oup      |
			|  evt_text_filters |  Groups           |  /Group/Subgroup                               |  ubg      |
			|  evt_text_filters |  Location         |  /UnitedStates/Austin                          |  states   |
			|  evt_text_filters |  Location         |  /UnitedStates/Austin                          |  stin     |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  uic      |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  row      |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  mps      |
			|  evt_text_filters |  Owner            |  name.surname                                  |  sur      |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  tem      |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  ell      |


		Examples: Full string search
			###
			# Search for a string typing the whole string
			# Example: for a field whose value is 'hello world' the following filters should be a match 'hello', 'world', 'hello world'
			###
			|      EVENT_ID     |   FIELD           |       VALUE                                    |  FILTER                                       |
			|  evt_text_filters |  Component        |  test_component                                |  test_component                               |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  Grandparent                                  |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  Parent                                       |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  Child                                        |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  /Grandparent/Parent/Child                    |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  Grandparent                                  |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  Parent                                       |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  Child                                        |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  /Grandparent/Parent/Child                    |
			|  evt_text_filters |  IP Address       |  128.10.10.1                                   |  128.10.10.1                                  |
			|  evt_text_filters |  Resource         |  test_device                                   |  test_device                                  |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  quick                                        |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  brown                                        |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  The quick brown fox jumps over the lazy dog  |
			|  evt_text_filters |  Agent            |  zentest                                       |  zentest                                      |
			|  evt_text_filters |  Collector        |  usa_collector1                                |  usa_collector1                               |
			|  evt_text_filters |  Event Class Key  |  myeventclasskey                               |  myeventclasskey                              |
			|  evt_text_filters |  Event Group      |  thisismygroup                                 |  thisismygroup                                |
			|  evt_text_filters |  Event ID         |  whatever                                      |  whatever                                     |
			|  evt_text_filters |  Event Key        |  randomEventKey                                |  randomEventKey                               |
			|  evt_text_filters |  Fingerprint      |  my_index_fingerprint                          |  my_index_fingerprint                         |
			|  evt_text_filters |  Groups           |  /Group/Subgroup                               |  Group                                        |
			|  evt_text_filters |  Groups           |  /Group/Subgroup                               |  Subgroup                                     |
			|  evt_text_filters |  Groups           |  /Group/Subgroup                               |  /Group/Subgroup                              |
			|  evt_text_filters |  Location         |  /UnitedStates/Austin                          |  UnitedStates                                 |
			|  evt_text_filters |  Location         |  /UnitedStates/Austin                          |  Austin                                       |
			|  evt_text_filters |  Location         |  /UnitedStates/Austin                          |  /UnitedStates/Austin                         |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  quick                                        |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  dog                                          |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  The quick brown fox jumps over the lazy dog  |
			|  evt_text_filters |  Owner            |  name.surname                                  |  name.surname                                 |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  hello                                        |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  Systems                                      |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  /Systems/hello                               |


		Examples: Implicit AND
			###
			# Search for a string typing a subset of the string characters ommitting the first n chars
			# Example: filter 'evi' should match 'device', 'devices', etc
			###
			|      EVENT_ID     |   FIELD           |       VALUE                                    |  FILTER      |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  quick jumps |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  brown dog   |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  over lazy   |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  quick jumps |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  brown dog   |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  over lazy   |


		Examples: Empty String
			###
			# Search for events that dont have a value for a specific field by filtering by ""
			# Example: filter 'dev' would match 'device', 'devices', etc
			###
			|        EVENT_ID          |   FIELD           |  VALUE  |  FILTER   |
			|  evt_empty_text_filters  |  Component        |   ""    |    ""     |
			|  evt_empty_text_filters  |  Device Class     |   ""    |    ""     |
			|  evt_empty_text_filters  |  IP Address       |   ""    |    ""     |
			|  evt_empty_text_filters  |  Agent            |   ""    |    ""     |
			|  evt_empty_text_filters  |  Collector        |   ""    |    ""     |
			|  evt_empty_text_filters  |  Event Class Key  |   ""    |    ""     |
			|  evt_empty_text_filters  |  Event Group      |   ""    |    ""     |
			|  evt_empty_text_filters  |  Event Key        |   ""    |    ""     |
			|  evt_empty_text_filters  |  Groups           |   ""    |    ""     |
			|  evt_empty_text_filters  |  Location         |   ""    |    ""     |
			|  evt_empty_text_filters  |  Owner            |   ""    |    ""     |
			|  evt_empty_text_filters  |  Systems          |   ""    |    ""     |



		Examples: String search with wildcard '*'
			###
			# Search for a string replacing a few adjacent characters with *
			# Example: filter 'devi*' would match 'device'
			###
			|      EVENT_ID     |   FIELD           |       VALUE                                    |  FILTER       |
			|  evt_text_filters |  Component        |  test_component                                |  tespo*       |
			|  evt_text_filters |  Component        |  test_component                                |  tes*ponent   |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  grand*       |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  par*t        |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  ch*d         |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  grand*       |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  par*t        |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  ch*d         |
			|  evt_text_filters |  IP Address       |  128.10.10.1                                   |  12*1         |
			|  evt_text_filters |  Resource         |  test_device                                   |  test*ice     |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  qu*k         |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  br*n         |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  jum*ver      |
			|  evt_text_filters |  Agent            |  zentest                                       |  zent*        |
			|  evt_text_filters |  Agent            |  zentest                                       |  zent*st      |
			|  evt_text_filters |  Collector        |  usa_collector1                                |  usa_*        |
			|  evt_text_filters |  Collector        |  usa_collector1                                |  usa_*1       |
			|  evt_text_filters |  Event Class Key  |  myeventclasskey                               |  myev*        |
			|  evt_text_filters |  Event Class Key  |  myeventclasskey                               |  myev*key     |
			|  evt_text_filters |  Event Group      |  thisismygroup                                 |  thisi*up     |
			|  evt_text_filters |  Event ID         |  whatever                                      |  what*r       |
			|  evt_text_filters |  Event Key        |  randomEventKey                                |  randomE*y    |
			|  evt_text_filters |  Fingerprint      |  my_index_fingerprint                          |  my_*print    |
			|  evt_text_filters |  Groups           |  /Group/Subgroup                               |  gr*p         |
			|  evt_text_filters |  Groups           |  /Group/Subgroup                               |  sub*p        |
			|  evt_text_filters |  Groups           |  /Group/Subgroup                               |  /Grou*bgroup |
			|  evt_text_filters |  Location         |  /UnitedStates/Austin                          |  uni*tes      |
			|  evt_text_filters |  Location         |  /UnitedStates/Austin                          |  aus*n        |
			|  evt_text_filters |  Location         |  /UnitedStates/Austin                          |  /UnitedS*stin|
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  qu*k         |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  b*n          |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  jum*ver      |
			|  evt_text_filters |  Owner            |  name.surname                                  |  name*me      |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  sy*s         |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  h*o          |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  /Systems/he* |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  /Syste*hello |


		Examples: String search with wildcard '?'
			###
			# Search for a string replacing one character with ?
			# Example: filter 'devi*e' would match 'device'
			###
			|      EVENT_ID     |   FIELD           |       VALUE                                    |    FILTER                   |
			|  evt_text_filters |  Component        |  test_component                                |  test_comp?nent             |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  Grandpar?nt                |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  Ch?ld                      |
			|  evt_text_filters |  Device Class     |  /Grandparent/Parent/Child                     |  /Grandparent/Pare?t/Child  |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  Grandpar?nt                |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  h?ld                       |
			|  evt_text_filters |  Event Class      |  /Grandparent/Parent/Child                     |  /Grandparent/Pare?t/Child  |
			|  evt_text_filters |  IP Address       |  128.10.10.1                                   |  128.1?.10.1                |
			|  evt_text_filters |  Resource         |  test_device                                   |  test?device                |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  qu?ck                      |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  ju?ps                      |
			|  evt_text_filters |  Summary          |  The quick brown fox jumps over the lazy dog   |  d?g                        |
			|  evt_text_filters |  Agent            |  zentest                                       |  zente?t                    |
			|  evt_text_filters |  Collector        |  usa_collector1                                |  usa?collector1             |
			|  evt_text_filters |  Event Class Key  |  myeventclasskey                               |  myevent?lasskey            |
			|  evt_text_filters |  Event Group      |  thisismygroup                                 |  thisism?group              |
			|  evt_text_filters |  Event ID         |  whatever                                      |  what?ver                   |
			|  evt_text_filters |  Event Key        |  randomEventKey                                |  rando?EventKey             |
			|  evt_text_filters |  Fingerprint      |  my_index_fingerprint                          |  my_index_?ingerprint       |
			|  evt_text_filters |  Groups           |  /Group/Subgroup                               |  Gro?p                      |
			|  evt_text_filters |  Groups           |  /Group/Subgroup                               |  Su?group                   |
			|  evt_text_filters |  Groups           |  /Group/Subgroup                               |  /Group/Subgr?up            |
			|  evt_text_filters |  Location         |  /UnitedStates/Austin                          |  United?tates               |
			|  evt_text_filters |  Location         |  /UnitedStates/Austin                          |  Aus?in                     |
			|  evt_text_filters |  Location         |  /UnitedStates/Austin                          |  /United?tates/Austin       |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  qu?ck                      |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  ju?ps                      |
			|  evt_text_filters |  Message          |  The quick brown fox jumps over the lazy dog   |  d?g                        |
			|  evt_text_filters |  Owner            |  name.surname                                  |  name?surname               |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  ?ystems                    |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  h?llo                      |
			|  evt_text_filters |  Systems          |  /Systems/hello                                |  /Systems?hello             |


	Scenario Outline: OR filters

		Given I am in the event console
		and I click on "Configure -> Restore defaults"
		and the "<FIELD>" and "Event ID" fields are visible
		and I use the Summary field to filter only the relevant events
		   ## both events for this test have "zenoss_test" in the summary
		when I type the following OR filter "<VALUE_1> || <VALUE_2>" for the "<FIELD>" field in the Zenoss UI
		then I can see both "<EVENT_ID_1>" and "<EVENT_ID_2>" events

		Examples: OR operator '||'
			###
			# Search for events whose va
			# Example: filter 'austin || chicago' for field location would match events whose location is one of tgiven
			###
			| EVENT_ID_1  |  EVENT_ID_2  |    FIELD         |   VALUE_1          |     VALUE_2        |
			|    evt_1    |     evt_2    |  Component       |  Component_1       |  Component_2       |
			|    evt_1    |     evt_2    | Device Class     |  Device_Class_1    |  Device_Class_2    | 
			|    evt_1    |     evt_2    | Event Class      |  Event_Class_1     |  Event_Class_2     |
  			|    evt_1    |     evt_2    | IP Address       |  1.1.1.1           |  2.2.2.2           |  
			|    evt_1    |     evt_2    | Resource         |  Resource_1        |  Resource_2        |    
			|    evt_1    |     evt_2    | Summary          |  Summary_1         |  Summary_2         |
			|    evt_1    |     evt_2    | Agent            |  Agent_1           |  Agent_2           |
			|    evt_1    |     evt_2    | Collector        |  Collector_1       |  Collector_2       | 
			|    evt_1    |     evt_2    | Event Class Key  |  Event_Class_Key_1 |  Event_Class_Key_2 |
			|    evt_1    |     evt_2    | Event Group      |  Event_Group_1     |  Event_Group_2     |
			|    evt_1    |     evt_2    | Event ID         |  Event_ID_1        |  Event_ID_2        |
			|    evt_1    |     evt_2    | Event Key        |  Event_Key_1       |  Event_Key_2       |
			|    evt_1    |     evt_2    | Fingerprint      |  Fingerprint_1     |  Fingerprint_2     |
			|    evt_1    |     evt_2    | Groups           |  Groups_1          |  Groups_2          |
			|    evt_1    |     evt_2    | Location         |  Location_1        |  Location_2        |
			|    evt_1    |     evt_2    | Message          |  Message_1         |  Message_2         |
			|    evt_1    |     evt_2    | Owner            |  Owner_1           |  Owner_2           |
			|    evt_1    |     evt_2    | Systems          |  Systems_1         |  Systems_2         |  


	Scenario Outline: NOT filters

		Given I am in the event console
		and I click on "Configure -> Restore defaults"
		and the "<FIELD>" and "Event ID" fields are visible
		and I use the Summary field to filter only the relevant events
		   ## both events for this test have "zenoss_test" in the summary
		when I type the following NOT filter "!! <VALUE_1>" for the "<FIELD>" field in the Zenoss UI
		then I can not see "<EVENT_ID_1>" and I can see "<EVENT_ID_2>"
		and  I clear the filter for "<FIELD>" field
		when I type the following NOT filter "!! <VALUE_2>" for the "<FIELD>" field in the Zenoss UI
		then I can not see "<EVENT_ID_2>" and I can see "<EVENT_ID_1>"

		Examples: NOT operator '!!'
			###
			# Search for events whose value does not contain the string we are filtering by
			# Example: filter '!!austin' for the location field would match events whose location is not austin
			###
			|  EVENT_ID_1  |  EVENT_ID_2  |     FIELD         |   VALUE_1          |     VALUE_2        |
			|    evt_1     |    evt_2     |  Component        |  Component_1       |  Component_2       |
			|    evt_1     |    evt_2     |  Device Class     |  Device_Class_1    |  Device_Class_2    | 
			|    evt_1     |    evt_2     |  Event Class      |  Event_Class_1     |  Event_Class_2     |
			|    evt_1     |    evt_2     |  IP Address       |  1.1.1.1           |  2.2.2.2           |  
			|    evt_1     |    evt_2     |  Resource         |  Resource_1        |  Resource_2        |    
			|    evt_1     |    evt_2     |  Summary          |  Summary_1         |  Summary_2         |
			|    evt_1     |    evt_2     |  Agent            |  Agent_1           |  Agent_2           |
			|    evt_1     |    evt_2     |  Collector        |  Collector_1       |  Collector_2       | 
			|    evt_1     |    evt_2     |  Event Class Key  |  Event_Class_Key_1 |  Event_Class_Key_2 |
			|    evt_1     |    evt_2     |  Event Group      |  Event_Group_1     |  Event_Group_2     |
			|    evt_1     |    evt_2     |  Event ID         |  Event_ID_1        |  Event_ID_2        |
			|    evt_1     |    evt_2     |  Event Key        |  Event_Key_1       |  Event_Key_2       |
			|    evt_1     |    evt_2     |  Fingerprint      |  Fingerprint_1     |  Fingerprint_2     |
			|    evt_1     |    evt_2     |  Groups           |  Groups_1          |  Groups_2          |
			|    evt_1     |    evt_2     |  Location         |  Location_1        |  Location_2        |
			|    evt_1     |    evt_2     |  Message          |  Message_1         |  Message_2         |
			|    evt_1     |    evt_2     |  Owner            |  Owner_1           |  Owner_2           |
			|    evt_1     |    evt_2     |  Systems          |  Systems_1         |  Systems_2         |  


	Scenario Outline: Sort Results

		Given I am in the event console
		and I click on "Configure -> Restore defaults"
		and the "<FIELD>" and "Event ID" fields are visible
		and I use the Summary field to filter only the relevant events
		   ## both events for this test have "zenoss_test" in the summary
		when I sort "<FIELD>" in "ascending" order
		then I see "<EVENT_ID_1>" above "<EVENT_ID_2>"
		when I sort "<FIELD>" in "descending" order
		then I see "<EVENT_ID_2>" above "<EVENT_ID_1>"

		Examples: Sort Results
			###
			|  EVENT_ID_1  |  EVENT_ID_2  |    FIELD         |   VALUE_1          |     VALUE_2        |
			|     evt_1    |    evt_2     |  Count           |       1            |         2          |
			|     evt_1    |    evt_2     |  Component       |  Component_1       |  Component_2       |
			|     evt_1    |    evt_2     | Device Class     |  Device_Class_1    |  Device_Class_2    |
			|     evt_1    |    evt_2     | Event Class      |  Event_Class_1     |  Event_Class_2     |
			|     evt_1    |    evt_2     | IP Address       |  1.1.1.1           |  2.2.2.2           |
			|     evt_1    |    evt_2     | Resource         |  Resource_1        |  Resource_2        |
			|     evt_1    |    evt_2     | Summary          |  Summary_1         |  Summary_2         |
			|     evt_1    |    evt_2     | Agent            |  Agent_1           |  Agent_2           |
			|     evt_1    |    evt_2     | Collector        |  Collector_1       |  Collector_2       |
			|     evt_1    |    evt_2     | Event Class Key  |  Event_Class_Key_1 |  Event_Class_Key_2 |
			|     evt_1    |    evt_2     | Event Group      |  Event_Group_1     |  Event_Group_2     |
			|     evt_1    |    evt_2     | Event ID         |  Event_ID_1        |  Event_ID_2        |
			|     evt_1    |    evt_2     | Event Key        |  Event_Key_1       |  Event_Key_2       |
			|     evt_1    |    evt_2     | Fingerprint      |  Fingerprint_1     |  Fingerprint_2     |
			|     evt_1    |    evt_2     | Location         |  Location_1        |  Location_2        |
			|     evt_1    |    evt_2     | Owner            |  Owner_1           |  Owner_2           |
			|     evt_1    |    evt_2     | Severity         |  Info              |  Warning           |
			|     evt_1    |    evt_2     | Status           |  New               |  Acknowledged      |
			|     evt_1    |    evt_2     | Device Priority  |  High              |  Highest           |
			|     evt_1    |    evt_2     | Production State |  Pre-Production    |  Production        |
			|     evt_1    |    evt_2     | First Seen       |  1443052800000     |  1443134289157     |
			|     evt_1    |    evt_2     | Last Seen        |  1443052800000     |  1443134289157     |
			|     evt_1    |    evt_2     | State Change     |  1443052800000     |  1443134289157     |


	Scenario Outline: IP Address Search

		Given I am in the event console
		and I click on "Configure -> Restore defaults"
		and the "<FIELD>" and "Event ID" fields are visible
		and I use the Summary field to filter only the relevant events
		   ## events for this test have "zenoss_test" in the summary
		and the following events have been created and indexed
			     | EVENT_ID |  IP_ADDRESS    |
			     | ip_evt_1 |  10.100.1.1    |
			     | ip_evt_2 |  10.111.1.2    |
			     | ip_evt_3 |  10.102.1.3    |
			     | ip_evt_4 |  10.200.10.4  |
		when I type "<FILTER>" as filter for the "IP Address" field in the Zenoss UI
		then I see these events "<FOUND_EVENTS>"
		and I can not see these events "<NOT_FOUND_EVENTS>"
		Examples: IP Address Search
			###
			|  FIELD       |  FILTER    |             FOUND_EVENTS                  |  NOT_FOUND_EVENTS                |
			|  IP Address  |    10      |   ip_evt_1, ip_evt_2, ip_evt_3, ip_evt_4  |  ""                              |
			|  IP Address  |    10.1    |   ip_evt_1, ip_evt_2, ip_evt_3            |  ip_evt_4                        |
			|  IP Address  |    10.10   |   ip_evt_1, ip_evt_3                      |  ip_evt_2, ip_evt_4              |
			|  IP Address  |    10.100  |   ip_evt_1                                |  ip_evt_2, ip_evt_3, ip_evt_4    |


	Scenario Outline: Number Search

		Given I am in the event console
		and I click on "Configure -> Restore defaults"
		and the "<FIELD>" and "Event ID" fields are visible
		and I use the Summary field to filter only the relevant events
		   ## events for this test have "zenoss_test" in the summary
		and the following events have been created and indexed
			     | EVENT_ID |  COUNT |
			     | evt_1    |    1   |
			     | evt_2    |    2   |
		when I type "<FILTER>" as filter for the "Count" field in the Zenoss UI
		then I see these events "<FOUND_EVENTS>"
		and I can not see these events "<NOT_FOUND_EVENTS>"

		Examples: Number Search
			###
			| FIELD |  FILTER   |  FOUND_EVENTS   |  NOT_FOUND_EVENTS   |
			| Count |    1      |     evt_1       |  evt_2              |
			| Count |    2      |     evt_2       |  evt_1              |

		Examples: Number Range Search
			###
			|  FIELD |  FILTER   |  FOUND_EVENTS  |  NOT_FOUND_EVENTS  |
			|  Count |    1:2    |  evt_1, evt_2  |    ""              |


	Scenario Outline: Date Search

		Given I am in the event console
		and I click on "Configure -> Restore defaults"
		and the "<FIELD>" and "Event ID" fields are visible
		and I use the Summary field to filter only the relevant events
		   ## events for this test have "zenoss_test" in the summary
		and the following events have been created and indexed
			     | EVENT_ID | First Seen          |  Last Seen           |
			     | evt_1    | 2015-09-23 19:00:00 | 2015-09-23 19:00:00  |
			     | evt_2    | 2015-09-24 17:38:09 | 2015-09-24 17:38:09  |
		when I type "<FILTER>" as filter for the "<FIELD>" field in the Zenoss UI
		then I see these events "<FOUND_EVENTS>"
		and I can not see these events "<NOT_FOUND_EVENTS>"

			Examples: Date Search
			###
			|   FIELD       |  FILTER                |  FOUND_EVENTS   |  NOT_FOUND_EVENTS   |
			|  First Seen   |  2015-09-28 20:00:00   |      ""         |  evt_1, evt_2       |
			|  First Seen   |  2015-09-24 00:00:00   |     evt_2       |  evt_1              |
			|  First Seen   |  2015-09-23 00:00:00   |  evt_1, evt_2   |  ""                 |
			|  Last Seen    |  2015-09-28 20:00:00   |      ""         |  evt_1, evt_2       |
			|  Last Seen    |  2015-09-24 00:00:00   |     evt_2       |  evt_1              |
			|  Last Seen    |  2015-09-23 00:00:00   |  evt_1, evt_2   |  ""                 |

			Examples: Date Range Search
			###
			|   FIELD      |  FILTER                                      |  FOUND_EVENTS   |  NOT_FOUND_EVENTS   |
			|  First Seen  |  2015-09-25 10:00:00 TO 2015-09-28 20:00:00  |      ""         |  evt_1, evt_2       |
			|  First Seen  |  2015-09-23 10:00:00 TO 2015-09-24 00:00:00  |     evt_1       |  evt_2              |
			|  First Seen  |  2015-09-23 10:00:00 TO 2015-09-24 23:00:00  |  evt_1, evt_2   |  ""                 |
			|  Last Seen   |  2015-09-25 10:00:00 TO 2015-09-28 20:00:00  |      ""         |  evt_1, evt_2       |
			|  Last Seen   |  2015-09-23 10:00:00 TO 2015-09-24 00:00:00  |     evt_1       |  evt_2              |
			|  Last Seen   |  2015-09-23 10:00:00 TO 2015-09-24 23:00:00  |  evt_1, evt_2   |  ""                 |

