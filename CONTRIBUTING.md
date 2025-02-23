# How to contribute

First off, thank you for considering contributing to Tenzu.

As this project is in its early stage, we are not yet able to accept most forms of contribution.
As such, we will only consider issues or PR about actual problem/limitation you are having with the provided helm charts.

In the meantime, we would love to hear from you at our [community website](https://community.tenzu.net).
Whether it be about ideas that you have, how you have been using Tenzu or any questions.
We are very active there and you'll be able to receive news about our progress!

## PR rules

- Always keep the documentation in sync with the change you have made.
- Please provide enough context and information to understand the change you are proposing (except if it is sufficiently self-explanatory)

## Prerequisite
We use [helm-docs](https://github.com/norwoodj/helm-docs) to automatically generate the readme of our charts.
For that to work, the comments of the values must be kept up-to-date.

We use helm-docs as a [precommit](https://pre-commit.com/) hook.
Ensure you have precommit installed (we recommend using `brew install pre-commit`)
and then run `pre-commit install` once, inside the repository, before making any commit.

Always check the generated changes in the READMEs afterward.


# Community
We are very active at our [community website](https://community.tenzu.net) and always happy to get in 
touch with our users there.

# Guide

## Security Issues

See [SECURITY](SECURITY.md)
