# ITDS362 Automated UI Testing Lab

This lab uses **Robot Framework (Part 3)** and **Cypress (Part 4)** to test the Selenium practice form and the QuickPizza QP-01 scenario. See [RESULTS.md](RESULTS.md) for the observations and evidence.

## Robot Framework

The [robot](robot/) folder contains the smoke test, form test, QP-01 scenario and shared SeleniumLibrary keywords. Use Python 3.10+ and Chrome. From `robot/`, install dependencies with `python -m pip install -r requirements.txt`. Set `CHROMEDRIVER` to an installed driver if needed. Otherwise Selenium Manager resolves it.

Run from `robot/`:

```sh
python -m robot -d results/local -v BROWSER:headlesschrome first.robot web_form.robot pizza_scenario.robot
```

## Cypress

The [cypress](cypress/) folder contains the Web Form and QP-01 specs, the shared admin login command and Chrome configuration. From `cypress/`, use Node.js 22, 24 or 26 and install dependencies with `npm ci`.

Run from `cypress/`:

```sh
npx cypress run --browser chrome
```

QuickPizza is a shared practice site. Run the tests only as needed. QP-01 uses a timestamped pizza name and leaves shared ratings intact.
