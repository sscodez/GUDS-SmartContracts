
# Sample Hardhat Project

Welcome to the Sample Hardhat Project! This repository demonstrates the basics of using [Hardhat](https://hardhat.org/), including deploying a sample smart contract, running tests, and interacting with Hardhat Ignition modules.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Hardhat Commands](#hardhat-commands)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

Before getting started, ensure you have the following installed on your machine:

- [Node.js](https://nodejs.org/en/) (v14.x or later)
- [npm](https://www.npmjs.com/) or [Yarn](https://yarnpkg.com/)
- [Git](https://git-scm.com/)

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/sample-hardhat-project.git
   cd sample-hardhat-project
   ```

2. **Install dependencies:**

   Using npm:

   ```bash
   npm install
   ```

   Or using Yarn:

   ```bash
   yarn install
   ```

## Usage

### Running Hardhat Tasks

This project includes several useful Hardhat tasks. Here are some commands you can run to interact with your project:

- **Display Hardhat help:**

  ```bash
  npx hardhat help
  ```

- **Run tests:**

  ```bash
  npx hardhat test
  ```

- **Run tests with gas reporting enabled:**

  ```bash
  REPORT_GAS=true npx hardhat test
  ```

- **Start a local Hardhat node:**

  ```bash
  npx hardhat node
  ```

- **Deploy contract using Hardhat Ignition:**

  ```bash
  npx hardhat ignition deploy ./ignition/modules/Lock.ts
  ```

### Additional Commands

You can add more commands and scripts in the `package.json` file to simplify your workflow. For example:

```json
"scripts": {
  "test": "npx hardhat test",
  "node": "npx hardhat node",
  "deploy": "npx hardhat ignition deploy ./ignition/modules/Lock.ts"
}
```

Now, you can run:

```bash
npm run test
npm run node
npm run deploy
```

## Project Structure

Here’s an overview of the project structure:

```
├── contracts            # Solidity contracts
├── tests                # Contract tests
├── scripts              # Helper scripts for deployment
├── ignition             # Hardhat Ignition modules (e.g., deploy modules)
├── hardhat.config.js    # Hardhat configuration file
├── package.json         # Project metadata and dependencies
└── README.md            # Project documentation (this file)
```

## Contributing

Contributions are welcome! If you’d like to report a bug, suggest an enhancement, or submit a pull request, please review the [CONTRIBUTING.md](CONTRIBUTING.md) guidelines.

## License

This project is licensed under the [MIT License](LICENSE).

---

Happy coding! If you run into any issues or have questions, feel free to open an issue.
```
