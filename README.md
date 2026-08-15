# Rescile CE — Nix Flake

[![Nix Flake](https://img.shields.io/badge/Nix-Flake-5277C3?logo=nixos\&logoColor=white)](https://nixos.org/)
[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-5277C3?logo=nixos\&logoColor=white)](https://nixos.org/)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

Nix flake for packaging and distributing **Rescile Community Edition (CE)**.

This repository provides reproducible Nix packaging for the pre-built Rescile CE binaries and integrates Rescile CE into the Nix ecosystem.

## Features

* Reproducible installation through Nix flakes
* Platform-specific Rescile CE binaries
* NixOS and `nix-darwin` compatibility
* `nix run` support
* `nix develop` development environment
* Version and binary integrity verification through Nix hashes
* Suitable as a flake input for other Nix configurations

## Supported Platforms

The current release supports:

| Platform | Architecture            | Status    |
| -------- | ----------------------- | --------- |
| Linux    | x86_64                  | Supported |
| macOS    | Apple Silicon / aarch64 | Supported |

Additional platforms may be added as Rescile CE binaries become available.

## Quick Start

### Run Rescile CE

With Nix installed and flakes enabled:

```bash
nix run github:rescile/nix_rescile
```

You can also specify the package explicitly:

```bash
nix run github:rescile/nix_rescile#rescile-ce
```

Check the installed version:

```bash
nix run github:rescile/nix_rescile -- --version
```

### Build the package

```bash
nix build github:rescile/nix_rescile
```

The resulting executable is available under:

```text
./result/bin/rescile-ce
```

## Using Rescile CE in Your Own Flake

Add this repository as a flake input:

```nix
{
  inputs = {
    rescile.url = "github:rescile/nix_rescile";
  };

  outputs = { self, nixpkgs, rescile, ... }:
    {
      # Your outputs...
    };
}
```

The package can then be referenced as:

```nix
rescile.packages.${system}.default
```

or:

```nix
rescile.packages.${system}.rescile-ce
```

For example:

```nix
environment.systemPackages = [
  rescile.packages.${pkgs.system}.default
];
```

## Development Environment

Clone the repository:

```bash
git clone https://github.com/rescile/nix_rescile.git
cd nix_rescile
```

Enter the development environment:

```bash
nix develop
```

The development shell can also be used with `direnv`:

```bash
echo "use flake" > .envrc
direnv allow
```

When activated, the development environment displays:

```text
Rescile CE devShell active
```

## Repository Structure

```text
.
├── flake.nix
├── flake.lock
├── pkgs/
│   └── package.nix
├── LICENSE
└── README.md
```

### `flake.nix`

Defines the flake inputs, supported systems, package outputs, and development shell.

### `pkgs/package.nix`

Contains the Nix derivation for Rescile CE, including:

* Upstream binary locations
* Platform selection
* SHA-256 integrity hashes
* Installation
* Linux binary patching
* Package metadata
* Version tests

## Updating the Rescile CE Version

The Rescile CE version is defined in:

```text
pkgs/package.nix
```

Update the version and corresponding upstream binary hashes for each supported platform.

For example:

```nix
let
  version = "0.1.195";
```

After updating the package, verify the flake:

```bash
nix flake check
```

Build it locally:

```bash
nix build
```

And test the resulting binary:

```bash
./result/bin/rescile-ce --version
```

## Binary Integrity

Rescile CE binaries are downloaded from the official Rescile update service during the Nix build.

Each binary is pinned using a SHA-256 hash:

```nix
sha256 = "...";
```

This allows Nix to verify that the downloaded artifact exactly matches the expected release binary.

The Nix package does not build Rescile CE from source. It packages the official pre-built release artifacts.

## Rescile CE

Rescile CE is the Community Edition of the Rescile platform.

Rescile provides infrastructure orchestration and automation across cloud and infrastructure environments, with an emphasis on repeatable infrastructure provisioning, dependency management, policy enforcement, and hybrid-cloud operation.

This repository is part of the broader Rescile ecosystem and focuses specifically on **Nix-based distribution and integration**.

## Contributing

Contributions are welcome.

Possible contributions include:

* Adding support for additional architectures
* Adding support for additional operating systems
* Improving Nix packaging
* Improving tests
* Improving documentation
* Adding NixOS modules
* Improving development tooling
* Reporting packaging or installation issues

### Development Workflow

1. Fork the repository.

2. Create a feature branch.

3. Make your changes.

4. Run the available checks:

   ```bash
   nix flake check
   ```

5. Build the package:

   ```bash
   nix build
   ```

6. Test the resulting binary.

7. Submit a pull request.

Please keep changes focused and include documentation where appropriate.

## Issues

If you encounter a problem with the Nix package, please open an issue and include:

* Operating system
* CPU architecture
* Nix version
* Nixpkgs revision
* Rescile CE version
* Relevant command output
* The output of `nix flake check --show-trace`, where applicable

For issues specific to the Rescile CE application itself, please use the appropriate Rescile CE issue tracker.

## License

This repository is licensed under the **Apache License 2.0**.

See [LICENSE](LICENSE) for the complete license text.

The license of this repository applies to the Nix packaging and associated repository content. Rescile CE binaries distributed through this flake remain subject to their applicable Rescile licensing terms.

## Community

Contributions, feedback, bug reports, and improvements are welcome.

The goal of this repository is to make Rescile CE easy to consume from the Nix ecosystem while keeping the packaging transparent, reproducible, and community-maintained.

---

**Rescile CE** · Infrastructure automation for the hybrid cloud
