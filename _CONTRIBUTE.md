# Contribution Guidelines
Thanks for taking you time to improve this GitHub repository.

## Version
Currently, the versioning system is:
+ Increment the patch version(`0.0.x`) sometimes when I feel like it.
+ Increment the minor version(`0.x.0`) when there are breaking changes.
    + Tipicaly this is happens when I refactor/rewrite the whole codebase.

## Test
To test the repository run `:checkhealth ultimate-autopair`.
If you want to run development checks and tests, set `_G.UA_DEV` to `true`.
Note: the tests don't cover all the features.

## Design
Unless the action modify the amount of pairs, you should not check whether the pairs are balanced

## Branch
It is recommended to use the `development` branch when creating a pull request and not the `main` branch.

## Commit messages
Commit messages should follow the [Conventional Commits](https://conventionalcommits.org/) format.
