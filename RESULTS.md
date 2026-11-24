# UI lab results

Tool parts chosen: Part 3 (Robot Framework) and Part 4 (Cypress).

## Part 0

- Chrome: 158.0.8127.38 (Windows).
- ChromeDriver: 158.0.8127.38 (Windows x64). The matching driver was downloaded from Chrome for Testing and passed to Robot via `CHROMEDRIVER`.
- Pizza, Please!: `button[name="pizza-please"]`.
- Excluded tools: `select` on the QuickPizza home page.
- Must be vegetarian: `#default-checkbox`.
- Custom Pizza Name: `input#pizza-name`.
- Max Calories per Slice: `//label[normalize-space()='Max Calories per Slice']/preceding-sibling::input`.

### QP-01 — A custom pizza reaches the admin list

Start on QuickPizza signed out. Use a timestamped `Lab Pizza YYYYMMDD-HHMMSS` name, a maximum of 600 calories per slice, Knife as the excluded tool, and the vegetarian option. Use the public demo admin account for step 6.

Manual run reported on 24 November 2026: `Lab Pizza 20261124-202030`, Pizza cutter, 550 calories per slice. Six steps passed and step 7 failed.

| Step | Action | Expected result | Manual actual result | Status |
| --- | --- | --- | --- | --- |
| 1 | Open the home page | Heading reads “Looking to break out of your pizza routine?” | The page showed “Looking to break out of your pizza routine?” | Pass |
| 2 | Turn on Advanced | All four restriction and name fields appear | Max Calories per Slice, Excluded tools, Must be vegetarian and Custom Pizza Name appeared | Pass |
| 3 | Enter 600, exclude Knife, select vegetarian and enter the name | All four fields show the chosen values | The form showed 600, Knife, the vegetarian checkbox selected and `Lab Pizza 20261124-202030` | Pass |
| 4 | Click Pizza, Please! | The custom name appears with a tool other than Knife and at most 600 calories per slice | `Lab Pizza 20261124-202030`, Pizza cutter, 550 calories per slice | Pass |
| 5 | Click Love it! as a guest | The page says “Please log in first.” | The page showed “Please log in first.” | Pass |
| 6 | Open /admin and sign in | “Latest pizza recommendations” appears | “Latest pizza recommendations” appeared with 15 entries | Pass |
| 7 | Find the exact pizza name in the list | The matching row shows the same tool as step 4 | None of the 15 displayed entries matched `Lab Pizza 20261124-202030` | Fail |

## Part 3 — Robot Framework

- Robot Framework 7.5.1, SeleniumLibrary 6.9.0, Selenium 4.54.0 and Python 3.12.10.
- Step 3.2 deliberately incorrect title: `Title should have been 'Wrong title' but was 'Web form'.`
- Step 3.8 run 1: 3 of 3 passed in 15.57 seconds. QP-01 passed in 8.85 seconds, with `Lab Pizza 20261124-201307`, Scissors and 600 calories per slice.
- Step 3.8 run 2: 3 of 3 passed in 20.22 seconds. QP-01 passed in 13.20 seconds, with `Lab Pizza 20261124-201326`, Pizza cutter and 475 calories per slice.
- Evidence: [run 1 log](robot/results/run1/log.html) and [run 2 log](robot/results/run2/log.html). Each folder contains the report, Robot XML and four QP-01 screenshots.

## Part 4 — Cypress

- Node.js 25.0.0, npm 11.6.2 and Cypress 15.21.2. These are the versions used on this machine.
- Step 4.3 deliberately incorrect title: `Timed out retrying after 15000ms`. Actual title: `Web form`. Expected title: `Wrong title`.
- Step 4.6 run 1 response from `POST /api/pizza`: Pizza cutter and 575 calories per slice.
- Step 4.7 run 1 admin row: `Lab Pizza 20261124-201151 (tool=Pizza cutter, ingredients_number=8)`.
- Step 4.8 run 1: 2 of 2 passed in 19 seconds, `Lab Pizza 20261124-201151`.
- Step 4.8 run 2: 2 of 2 passed in 14 seconds, `Lab Pizza 20261124-201316`, Scissors and 500 calories per slice.
- Evidence from the final run: [screenshots](cypress/cypress/screenshots/) and [videos](cypress/cypress/videos/).

## Part B — Reflection

1. The QuickPizza Advanced form reuses `floating_filled` across multiple number inputs. The XPath uses the “Max Calories per Slice” label to identify the input that received 600 in QP-01. Giving the input a unique ID such as `max-calories-per-slice` and setting the label's `for` to the same value would give tests a direct selector and correctly associate the label with its control.

2. Step 7 uses a consistency oracle across the customer and admin views. In the first Cypress run the page showed Pizza cutter, and the admin row for `Lab Pizza 20261124-201151` had to report Pizza cutter too. The comparison could catch a storage or rendering bug that attaches another pizza's tool to the correct name.

3. To verify the vegetarian restriction, check each recommended ingredient against a maintained list or an explicit dietary field from the ingredient catalog. QP-01 currently verifies that the checkbox was selected, which only establishes what the customer asked for. The test would need a complete list of actual ingredients and reliable classifications for items whose dietary status is ambiguous, such as cheeses with animal rennet.

4. Robot uses explicit SeleniumLibrary waits such as `Wait Until Element Contains`. Cypress retries UI assertions and waits for the aliased pizza response, which made it quicker to write the request and UI checks together. Robot took more setup because the browser driver and reusable resource keywords were separate. Its HTML log shows each keyword and the captured images, while the Cypress video shows the UI beside the command log. In the wrong-title exercise Robot printed the two title strings, and Cypress displayed their difference after the 15-second retry window.

5. I would use Cypress for Project 2. It let me check the actual calorie limit in the outgoing request and compare the server response with the displayed recommendation in the same test. The videos also make it possible to review both the UI and command sequence from a headless run.

6. For Robot Framework, change `${MAX CALORIES}` in `robot/resources/quickpizza.resource` if the locator changes. Both the visibility check and the input and value assertions already use that variable. The scenario in `pizza_scenario.robot` can keep calling the same keywords with the same test data.

7. Cypress test isolation resets browser state such as cookies and clears aliases between tests. Steps 6 and 7 need the pizza name generated by the customer flow and the exact tool captured from its response. Moving those steps into an independent test would clear the tool alias and require another explicit mechanism to share the generated name and tool, making the admin check depend on another test having run first.
