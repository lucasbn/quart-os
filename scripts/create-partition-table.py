import struct
import sys

class PartitionEntry:
    def __init__(self, ptype, start_lba, num_sectors, bootable=False):
        self.ptype = ptype
        self.start_lba = start_lba
        self.num_sectors = num_sectors
        self.bootable = bootable

    def to_bytes(self):
        boot_flag = 0x80 if self.bootable else 0x00
        chs_start = b"\x01\x01\x00"
        chs_end   = b"\xFE\xFF\xFF"
        return struct.pack("<B3sB3sII",
                           boot_flag,
                           chs_start,
                           self.ptype,
                           chs_end,
                           self.start_lba,
                           self.num_sectors)

class PartitionTable:
    def __init__(self):
        self.entries = []

    def add_partition(self, entry: PartitionEntry):
        if len(self.entries) >= 4:
            raise ValueError("Maximum of 4 partitions allowed")
        self.entries.append(entry)

    def get_bytes(self):
        data = b"".join(e.to_bytes() for e in self.entries)
        while len(data) < 64:
            data += b"\x00" * 16
        data += b"\x55\xAA"
        return data
            
if __name__ == "__main__":
    pt = PartitionTable()
    pt.add_partition(PartitionEntry(ptype=0x01, start_lba=1, num_sectors=128, bootable=True))
    pt.add_partition(PartitionEntry(ptype=0x02, start_lba=128, num_sectors=128, bootable=False))
    pt.add_partition(PartitionEntry(ptype=0x03, start_lba=256, num_sectors=128, bootable=False))
    pt.add_partition(PartitionEntry(ptype=0x04, start_lba=385, num_sectors=128, bootable=False))
    
    # Write bytes directly to stdout
    sys.stdout.buffer.write(pt.get_bytes())