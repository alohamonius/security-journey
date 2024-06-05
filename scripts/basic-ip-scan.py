import subprocess
import os


def scan_open_ports(domain):
    # Nmap scan to detect open ports
    print("Scanning open ports using Nmap...")
    nmap_output = subprocess.run(['nmap', '-v','-p-', domain], capture_output=True, text=True)
    print(nmap_output.stdout)

def dirb_scan(domain):
    # Dirb scan for directory enumeration
    print("Scanning directories using Dirb...")
    dirb_output = subprocess.run(['dirb', f"http://{domain}"], capture_output=True, text=True)
    print(dirb_output.stdout)

def amass_scan(domain):
    # Amass scan for subdomain enumeration
    print("Enumerating subdomains using Amass...")
    amass_output = subprocess.run(['amass', 'enum', '-d', domain], capture_output=True, text=True)
    print(amass_output.stdout)


if __name__ == "__main__":
    ip = input("Enter the domain name to scan (e.g., example.com): ")

    os.system(f"nmap -p- -v {ip}")
    