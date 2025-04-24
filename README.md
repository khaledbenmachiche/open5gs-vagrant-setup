# 5G in a Box: Open5GS + UERANSIM with Vagrant

This project automates the setup of a 5G core network using **Open5GS** and a simulated 5G Radio Access Network (RAN) with **UERANSIM**, running on two virtual machines orchestrated by **Vagrant** with the **VMware Desktop** provider. Open5GS provides a fully functional 5G Core (5GC), while UERANSIM simulates User Equipment (UE) and gNodeB (gNB) for end-to-end network testing.

## Components

- **Open5GS**: Open-source 5G Core Network implementation (AMF, SMF, UPF, etc.).
- **UERANSIM**: Simulator for 5G UE and gNB.
- **MongoDB**: Database for Open5GS subscriber data.
- **Node.js**: Powers the Open5GS WebUI for subscriber management.

##  Prerequisites

- [Vagrant](https://www.vagrantup.com/) installed.
- [VMware Desktop](https://www.vmware.com/products/workstation-pro.html) (or VirtualBox with Vagrant provider adjustments).
- Git installed on the host machine.
- Internet connection for initial package downloads.
- Host machine with at least 8GB RAM and 4 CPU cores (2GB RAM and 2 CPUs per VM).

##  Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/khaledbenmachiche/5ginabox.git
   cd 5ginabox
   ```

2. **Launch the VMs**:
   ```bash
   vagrant up
   ```

This creates two VMs:
- `open5gs.local` (IP: `192.168.56.101`): Hosts Open5GS, MongoDB, and WebUI.
- `ueransim.local` (IP: `192.168.56.102`): Hosts UERANSIM for gNB and UE simulation.

##  Provisioning Details

### Open5GS Setup (`installation/open5gs.sh`)
- Installs MongoDB (version 6.0) from the official repository.
- Adds the Open5GS PPA and installs Open5GS.
- Installs Node.js (version 20) and the Open5GS WebUI.
- Enables and starts the MongoDB service.

### UERANSIM Setup (`installation/ueransim.sh`)
- Installs dependencies (CMake, SCTP, gcc, tcpdump, etc.).
- Clones the UERANSIM repository from GitHub.
- Compiles UERANSIM for gNB and UE simulation.

##  Project Structure

```
.
├── installation/
│   ├── open5gs.sh         # Open5GS installation script
│   └── ueransim.sh        # UERANSIM installation script
├── Vagrantfile            # Vagrant configuration for VM setup
├── .gitignore             # Git ignore file
├── README.md              # This file
├── Readme.md              # Additional documentation
```

##  Networking

- **Open5GS WebUI**: Accessible at `http://localhost:8080` (mapped to `192.168.56.101:3000`).
- **SCTP Port**: Forwarded from `38412` (Open5GS) and `38413` (UERANSIM) for NGAP communication.
- **Private Network**: VMs communicate over `192.168.56.0/24` (Open5GS: `192.168.56.101`, UERANSIM: `192.168.56.102`).

## Testing

1. **Verify Open5GS Services**:
   ```bash
   vagrant ssh open5gs
   sudo systemctl status open5gs*
   ```

2. **Access Open5GS WebUI**:
   - Navigate to `http://localhost:8080`.
   - Default credentials: `admin`/`free5gc` (update after login).
   - Add a subscriber (e.g., IMSI: `001010000000001`, Key: `8baf473f2f8fd09487cccbd7097c6862`, OP: `8e27b6af0e692e750f32667a3b14605d`).

3. **Configure UERANSIM**:
   ```bash
   vagrant ssh ueransim
   cd ~/UERANSIM/config
   ```
   - Edit `open5gs-gnb.yaml`:
     ```yaml
     linkIp: 192.168.56.102
     ngapIp: 192.168.56.102
     gtpIp: 192.168.56.102
     amfConfigs:
       - address: 192.168.56.101
         port: 38412
     ```
   - Edit `open5gs-ue.yaml`:
     ```yaml
     supi: 'imsi-001010000000001'
     mcc: '001'
     mnc: '01'
     key: '8baf473f2f8fd09487cccbd7097c6862'
     op: '8e27b6af0e692e750f32667a3b14605d'
     opType: 'OP'
     gnbSearchList:
       - 192.168.56.102
     ```

4. **Run UERANSIM**:
   - Start gNB:
     ```bash
     cd ~/UERANSIM/build
     ./nr-gnb -c ../config/open5gs-gnb.yaml
     ```
   - In a new terminal, start UE:
     ```bash
     vagrant ssh ueransim
     cd ~/UERANSIM/build
     sudo ./nr-ue -c ../config/open5gs-ue.yaml
     ```

5. **Test Connectivity**:
   - Verify UE registration in UERANSIM logs (look for `uesimtun0` interface).
   - Test data connectivity:
     ```bash
     ping -I uesimtun0 8.8.8.8
     ```

## Notes

- **VM Customization**: Adjust CPU and RAM in `Vagrantfile` (default: 2 CPUs, 2048MB RAM per VM).
- **Provider**: VMware Desktop is used by default. For VirtualBox, update `Vagrantfile` to use `provider: virtualbox`.
- **Performance**: UERANSIM and Open5GS are not optimized for high throughput; increase VM resources for better performance.
- **Configuration**: Ensure subscriber details in the Open5GS WebUI match UERANSIM’s `open5gs-ue.yaml`.

##  License

This project is licensed under the MIT License.

## Author

**Khaled Benmachiche**  
GitHub: [@khaledbenmachiche](https://github.com/khaledbenmachiche)

## Acknowledgments

- [Open5GS](https://open5gs.org) for the 5G core implementation.
- [UERANSIM](https://github.com/aligungr/UERANSIM) for the 5G UE and gNB simulator.
- [Vagrant](https://www.vagrantup.com) for VM automation.

```

- The README is concise yet comprehensive, avoiding speculative features and focusing on practical usage. Let me know if you need further adjustments or additional sections!
