#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.13"
# dependencies = ["psutil"]
# ///

import platform
from datetime import datetime

import psutil
import rich


def get_size(bytes, suffix="B"):
    """
    Scale bytes to its proper format
    e.g:
        1253656 => '1.20MB'
        1253656678 => '1.17GB'
    """
    factor = 1024
    for unit in ["", "K", "M", "G", "T", "P"]:
        if bytes < factor:
            return f"{bytes:.2f}{unit}{suffix}"
        bytes /= factor


def print_system_info():
    print("=" * 40, "System Information", "=" * 40)
    uname = platform.uname()
    print(f"System: {uname.system}")
    print(f"Node Name: {uname.node}")
    print(f"Release: {uname.release}")
    print(f"Version: {uname.version}")
    print(f"Machine: {uname.machine}")
    print(f"Processor: {uname.processor}")


def print_boot_time():
    print("=" * 40, "Boot Time", "=" * 40)
    boot_time_timestamp = psutil.boot_time()
    bt = datetime.fromtimestamp(boot_time_timestamp)
    print(f"Boot Time: {bt.year}/{bt.month}/{bt.day} {bt.hour}:{bt.minute}:{bt.second}")


def print_cpu_info():
    print("=" * 40, "CPU Info", "=" * 40)
    print("Physical cores:", psutil.cpu_count(logical=False))
    print("Total cores:", psutil.cpu_count(logical=True))
    cpufreq = psutil.cpu_freq()
    print(f"Max Frequency: {cpufreq.max:.2f}Mhz")
    print(f"Min Frequency: {cpufreq.min:.2f}Mhz")
    print(f"Current Frequency: {cpufreq.current:.2f}Mhz")
    print("CPU Usage Per Core:")
    for i, percentage in enumerate(psutil.cpu_percent(percpu=True, interval=1)):
        print(f"Core {i}: {percentage}%")
    print(f"Total CPU Usage: {psutil.cpu_percent()}%")


def print_memory_info():
    print("=" * 40, "Memory Information", "=" * 40)
    svmem = psutil.virtual_memory()
    print(f"Total: {get_size(svmem.total)}")
    print(f"Available: {get_size(svmem.available)}")
    print(f"Used: {get_size(svmem.used)}")
    print(f"Percentage: {svmem.percent}%")

    print("=" * 20, "SWAP", "=" * 20)
    swap = psutil.swap_memory()
    print(f"Total: {get_size(swap.total)}")
    print(f"Free: {get_size(swap.free)}")
    print(f"Used: {get_size(swap.used)}")
    print(f"Percentage: {swap.percent}%")


def print_disk_info():
    print("=" * 40, "Disk Information", "=" * 40)
    partitions = psutil.disk_partitions()
    for partition in partitions:
        print(f"=== Device: {partition.device} ===")
        print(f"  Mountpoint: {partition.mountpoint}")
        print(f"  File system type: {partition.fstype}")
        try:
            partition_usage = psutil.disk_usage(partition.mountpoint)
        except PermissionError:
            continue
        print(f"  Total Size: {get_size(partition_usage.total)}")
        print(f"  Used: {get_size(partition_usage.used)}")
        print(f"  Free: {get_size(partition_usage.free)}")
        print(f"  Percentage: {partition_usage.percent}%")
    disk_io = psutil.disk_io_counters()
    print(f"Total read: {get_size(disk_io.read_bytes)}")
    print(f"Total write: {get_size(disk_io.write_bytes)}")


def print_network_info():
    print("=" * 40, "Network Information", "=" * 40)
    if_addrs = psutil.net_if_addrs()
    for interface_name, interface_addresses in if_addrs.items():
        print(f"=== Interface: {interface_name} ===")
        for addr in interface_addresses:
            print(f"  IP Address: {addr.address}")
            print(f"  Netmask: {addr.netmask}")
            print(f"  Broadcast IP: {addr.broadcast}")
    net_io = psutil.net_io_counters()
    print(f"Total Bytes Sent: {get_size(net_io.bytes_sent)}")
    print(f"Total Bytes Received: {get_size(net_io.bytes_recv)}")


def print_process_info():
    print("=" * 40, "Process Information", "=" * 40)
    print("Top 5 processes by CPU usage:")
    processes = sorted(
        psutil.process_iter(["pid", "name", "cpu_percent"]),
        key=lambda x: x.info["cpu_percent"],
        reverse=True,
    )
    for proc in processes[:5]:
        print(
            f"PID: {proc.info['pid']}, Name: {proc.info['name']}, CPU: {proc.info['cpu_percent']}%"
        )

    print("\nTop 5 processes by Memory usage:")
    processes = sorted(
        psutil.process_iter(["pid", "name", "memory_percent"]),
        key=lambda x: x.info["memory_percent"],
        reverse=True,
    )
    for proc in processes[:5]:
        print(
            f"PID: {proc.info['pid']}, Name: {proc.info['name']}, Memory: {proc.info['memory_percent']:.2f}%"
        )


if __name__ == "__main__":
    print_system_info()
    print_boot_time()
    print_cpu_info()
    print_memory_info()
    print_disk_info()
    print_network_info()
    print_process_info()
