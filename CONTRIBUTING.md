-   [Overview](#overview)
    -   [Project approach](#project-approach)
    -   [Making Contributions](#making-contributions)
    -   [Issue reporting and handling](#issue-reporting-and-handling)
    -   [Contributing to this GitHub repository](#contributing-to-this-github-repository)
        -   [Repository structure](#repository-structure)
    -   [Contributing to Development](#contributing-to-development)
        -   [User Stories](#user-stories)
        -   [Reporting User Story Status](#reporting-user-story-status)
        -   [Project Status](#project-status)
    -   [Communications mechanisms](#communications-mechanisms)
-   [Licenses and attribution](#licenses-and-attribution)
    -   [This project is in the public domain](#this-project-is-in-the-public-domain)
    -   [Contributions will be released into the public domain](#contributions-will-be-released-into-the-public-domain)

# Overview

This page is for potential contributors to this project. It provides basic information on the project, describes the main ways people can make contributions, explains how to report issues relating to the project and project artifacts, and lists pointers to additional sources of information.

## Project approach

We track our current work items using GitHub repository's [issues](../../issues).

## Making Contributions

Contributions of code and documentation are welcome to this repository.

For more information on the project's current needs and priorities, see the project's GitHub issue tracker (discussed below). Please refer to the [guide on how to contribute to open source](https://opensource.guide/how-to-contribute/) for general information on contributing to an open source project.

## Issue reporting and handling

All requests for changes and enhancements to the repository are initiated through the project's [GitHub issue tracker](../../issues). To initiate a request

- [Create a new issue](https://help.github.com/articles/creating-an-issue/).

## Contributing to this GitHub repository

This project uses a typical GitHub fork and pull request [workflow](https://guides.github.com/introduction/flow/). To establish a development environment for contributing to the project, you must do the following:

1. Fork the repository to your personal workspace. Please refer to the Github [guide on forking a repository](https://help.github.com/articles/fork-a-repo/) for more details.
1. Create a feature branch from the `main` branch for making changes. You can [create a branch in your personal repository](https://help.github.com/articles/creating-and-deleting-branches-within-your-repository/) directly on GitHub or create the branch using a Git client. For example, the `git branch working` command can be used to create a branch named _working_.
1. You will need to make your modifications by adding, removing, and changing the content in the branch, then staging your changes using the `git add` and `git rm` commands.
1. Once you have staged your changes, you will need to commit them. When committing, you will need to include a commit message. The commit message should describe the nature of your changes (e.g., added new feature X which supports Y). You can also reference an issue from the OSCAL repository by using the hash symbol. For example, to reference issue #34, you would include the text "#34". The full command would be: `git commit -m "added new feature X which supports Y addressing issue #34"`.
1. Next, you must push your changes to your personal repo. You can do this with the command: `git push`.
1. Finally, you can [create a pull request](https://help.github.com/articles/creating-a-pull-request-from-a-fork/).
    - Please allow the NIST OSCAL maintainers to make changes to your pull request, to efficiently merge it, by selecting on your fork the setting to [always allow edits from the maintainers](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/allowing-changes-to-a-pull-request-branch-created-from-a-fork).
    - Review [the OSCAL release and versioning strategy](./versioning-and-branching.md) and [choose the base branch](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/changing-the-base-branch-of-a-pull-request) accordingly.

### Repository structure

This repository consists of the following directories and documentation files pertaining to the project:

-   [.github](.github): Contains GitHub issue and pull request templates, and GitHub action workflows for the project.
-   [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md): This file contains a code of conduct for all project contributors.
-   [CONTRIBUTING.md](CONTRIBUTING.md): This file is for potential contributors to the project. It provides basic information on the project, describes the main ways people can make contributions, explains how to report issues, and lists pointers to additional sources of information. It also has instructions on establishing a development environment for contributing to the project and using GitHub project cards to track development sprints.
-   [LICENSE.md](LICENSE.md): This file contains license information for the files in this GitHub repository.

All other files and directories are related to the XSLT codebase managed in this repository.

## Contributing to Development

This project is using the GitHub repository's [issues](../../issues) to track development as part of the core project work stream.

## Communications mechanisms

This project originated as part of the [Open Security Controls Assessment Language](https://pages.nist.gov/OSCAL/) (OSCAL) project. We use the OSCAL communications channels for this project as well.

A Gitter [chat room](https://gitter.im/usnistgov-OSCAL/metaschema) is available for Metaschema-related discussions. This is a great place to discuss issues pertaining to this work with the community working with Metaschema. The NIST OSCAL team actively chats on the OSCAL Gitter. This room is also setup with Github integration, which provides a good summary of recent Github repo activities within the chat room.

There are two OSCAL mailing lists, which may also be used for this project.

-   **OSCAL Developer List:** [oscal-dev@list.nist.gov](mailto:oscal-dev@list.nist.gov) for communication among parties interested in contributing to the development of OSCAL or exchanging ideas. Subscribe by sending an email to [oscal-dev+subscribe@list.nist.gov](mailto:oscal-dev+subscribe@list.nist.gov). To unsubscribe send an email to [oscal-dev+unsubscribe@list.nist.gov](mailto:oscal-dev+unsubscribe@list.nist.gov).
-   **OSCAL Updates List:** [oscal-updates@list.nist.gov](mailto:oscal-updates@list.nist.gov) for low-frequency updates on the status of the OSCAL project. Subscribe by sending an email to [oscal-updates+subscribe@list.nist.gov](mailto:oscal-updates+subscribe@list.nist.gov). To unsubscribe send an email to [oscal-updates+unsubscribe@list.nist.gov](mailto:oscal-updates+unsubscribe@list.nist.gov).

Note that the contact points offered above are subject to change without notice.

# Licenses and attribution

## This project is in the public domain

This project is in the worldwide public domain.

This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain](https://creativecommons.org/publicdomain/zero/1.0/) dedication.

## Contributions will be released into the public domain

All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
