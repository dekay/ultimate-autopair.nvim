# Contribution Guidelines
Thanks for taking you time to improve this GitHub repository.

## Version
Currently, the versioning system is:
+ Increment the patch version(`0.0.x`) sometimes when I feel like it.
+ Increment the minor version(`0.x.0`) when there are major breaking changes.
    + Minor breaking changes don't cause a version bump.

## Test
To run the tests: set `_G.UA_DEV=true` and run `:checkhealth ultimate-autopair` (you can ignore unrelated warnings).

## Design
Unless the action modify the amount of pairs, you should not check whether the pairs are balanced

## Branch
It is recommended to use the `development` branch when creating a pull request and not the `main` branch.

## Commit messages
Commit messages should follow the [Conventional Commits](https://conventionalcommits.org/) format.
