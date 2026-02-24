# acm (acm)

[![Build](https://github.com/sestrella/acm/actions/workflows/build.yml/badge.svg)](https://github.com/sestrella/acm/actions/workflows/build.yml)

Generates a commit message from a `git diff` using AI.

**Features**

- Supports OpenAI-like providers, with Gemini as the default.
- Improve commit messages by switching to a model based on diff size.

![demo](demo.gif)

> [!NOTE] 
> The [commit messages](https://github.com/sestrella/acm/commits/main/)
> for this project were generated using this tool.

## Installation

Download the precompiled binary from the [releases] page that matches your current
system. Unzip the file and place the binary in a location available on your
`PATH` environment variable.

<details open>

<summary>Instructions for non-Nix users</summary>

### pre-commit

Add a `.pre-commit-config.yaml` file to your project's root directory with the
following content:

```yml
- repo: local
  hooks:
    - id: acm
      name: acm
      entry: acm
      language: system
      stages: [prepare-commit-msg]
```

</details>

<details>

<summary>Instructions for Nix users</summary>

### devenv

Add the `acm` input to the `devenv.yaml` file:

```yml
inputs:
  acm:
    url: github:sestrella/acm
    overlays: [default]
  nixpkgs:
    url: github:cachix/devenv-nixpkgs/rolling
```

Add the `acm` hook to the `devenv.nix` file as follows:

```nix
{ pkgs, lib, ... }:

{
  dotenv.enable = true;

  git-hooks.hooks.acm = {
    enable = true;
    entry = lib.getExe pkgs.acm;
    stages = [ "prepare-commit-msg" ];
  };

  cachix.pull = [ "sestrella" ];
}
```

**Note:** Enabling `dotenv` is optional if the `OPENAI_API_KEY` environment
variable is available.

</details>

## Configuration

`acm` can be configured via a `.acm.toml` file in
the project's root directory or the user's home directory. The available
configuration parameters are:

- **`trace`**: When `true`, appends acm execution traces to the commit message.
  - **Default**: `false`

  The following metrics are appended to the commit message when trace is enabled:

  - **`Version`**: The version of the `acm` command used.
  - **`Model`**: The model used to generate the commit message.
  - **`ResponseTime`**: The time it took to get a response from the AI model.
  - **`ExecutionTime`**: The total time it took for the `acm` command to execute.

- **`provider.base_url`**: The base URL of the OpenAI-like provider.
  - **Default**: `https://generativelanguage.googleapis.com/v1beta/openai`
- **`provider.api_key`**: The name of the environment variable that contains the API key.
  - **Default**: `GEMINI_API_KEY`
- **`diff.short_model`**: The model to use for diffs with fewer lines than `diff.threshold`.
  - **Default**: `gemini-2.5-flash-lite`
- **`diff.long_model`**: The model to use for diffs with more lines than `diff.threshold`.
  - **Default**: `gemini-2.5-flash`
- **`diff.threshold`**: The line count threshold to switch between `diff.short_model` and `diff.long_model`.
  - **Default**: `500`

Here is an example `.acm.toml` file:

```toml
trace = true

[provider]
base_url = "https://api.openai.com/v1"
api_key = "OPENAI_API_KEY"

[diff]
short_model = "gpt-4.1-mini"
long_model = "o4-mini"
threshold = 250
```

## Usage

After setting `acm` as a [prepare-commit-msg] hook, invoking `git
commit` without a commit message generates a commit message. If a commit message
is given, `acm` does not generate a commit message and instead uses
the one provided by the user.

## License

[MIT](LICENSE)

[prepare-commit-msg]: https://git-scm.com/docs/githooks#_prepare_commit_msg
[releases]: https://github.com/sestrella/acm/releases
