# Pycon India App

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Conference App for PyCon India

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ task run-dev

# Staging
$ task run-staging

# Production
$ task run-prod
```

## Running Tests 🧪

To run all tests use the following command:

```sh
task run-vg-tests
```

To view the generated coverage report you can use lcov.

```sh
# Generate Coverage Report
$ task run-vg-tests-coverage

# Open Coverage Report
$ open coverage/index.html
```

<!-- Support Links -->
[coverage_badge]: coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
