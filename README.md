<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
* [Built With](#built-with)
* [Getting Started](#getting-started)
* [Prerequisites](#prerequisites)
* [Installation](#installation)
* [Roadmap](#roadmap)
* [Contributing](#contributing)
* [Contact](#contact)



<!-- ABOUT THE PROJECT -->
## About The Project

Opensource OpenVPN setup with Terraform and scripts that handle user creation integrated with Terraform, and ovpn file transfer using AWS SES service.

### Built With

* [Terraform](https://terraform.io)
* [OpenVPN](https://openvpn.com)
* [Yaml](https://yaml.com)


## Getting Started

Locate in the directory tf/main.
On Instance install pwgen and awscli.
   $ sudo amazon-linux-extras install epel -y
   $ sudo yum install pwgen
   $ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   $ unzip awscliv2.zip
   $ sudo ./aws/install

### Prerequisites

Terraform version 1.3.6 +

<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/m-stojanovic/terraform-openvpn-infrastructure/issues) for a list of proposed features (and known issues).

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- CONTACT -->
## Contact

Milos Stojanovic - [@linkedin](https://www.linkedin.com/in/infomilosstojanovic/)

Project Link: [https://github.com/m-stojanovic/terraform-openvpn-infrastructure](https://github.com/m-stojanovic/terraform-openvpn-infrastructure)