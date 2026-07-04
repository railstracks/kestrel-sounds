#!/usr/bin/env python3
"""Convert SuperCollider synthdef v2 to v1 format for Sonic Pi 3.x compatibility.

Sonic Pi 3.2.x loads synthdef v1 files (int16 count fields).
SuperCollider 3.13.0 compiles to v2 format (int32 count fields).
This converter reads v2 and re-emits as v1.

Usage: python3 v2_to_v1.py <input.scsyndef> <output.scsyndef>
"""
import struct
import sys


def rpstring(data, pos):
    """Read pascal string (int8 len + bytes), NO padding."""
    n = data[pos]
    pos += 1
    s = data[pos:pos + n]
    pos += n
    return s, pos


def rint32(data, pos):
    return struct.unpack('>I', data[pos:pos + 4])[0], pos + 4


def rint16(data, pos):
    return struct.unpack('>h', data[pos:pos + 2])[0], pos + 2


def rint8(data, pos):
    return data[pos], pos + 1


def rfloat32(data, pos):
    return struct.unpack('>f', data[pos:pos + 4])[0], pos + 4


def wpstring(s):
    if isinstance(s, str):
        s = s.encode()
    return bytes([len(s)]) + s


def wint16(v):
    return struct.pack('>h', v)


def wint32(v):
    return struct.pack('>I', v)


def wfloat32(v):
    return struct.pack('>f', v)


def wint8(v):
    return bytes([v])


def convert(inp, outp):
    with open(inp, 'rb') as f:
        data = f.read()

    pos = 0
    magic = data[pos:pos + 4]
    pos += 4
    assert magic == b'SCgf', f'Not a synthdef file: {magic}'

    ver, pos = rint32(data, pos)
    assert ver == 2, f'Expected v2, got v{ver}'

    ndefs, pos = rint16(data, pos)

    out = b'SCgf' + wint32(1) + wint16(ndefs)

    for _ in range(ndefs):
        # Synth name (pstring)
        name, pos = rpstring(data, pos)
        out += wpstring(name)

        # Constants: int32 count -> int16
        nc, pos = rint32(data, pos)
        out += wint16(nc)
        for _ in range(nc):
            v, pos = rfloat32(data, pos)
            out += wfloat32(v)

        # Parameters: int32 count -> int16
        np_, pos = rint32(data, pos)
        out += wint16(np_)
        for _ in range(np_):
            v, pos = rfloat32(data, pos)
            out += wfloat32(v)

        # Parameter names: int32 count -> int16
        npn, pos = rint32(data, pos)
        out += wint16(npn)
        for _ in range(npn):
            pn, pos = rpstring(data, pos)
            out += wpstring(pn)
            idx, pos = rint32(data, pos)
            out += wint32(idx)  # param index stays int32

        # Unit generators: int32 count -> int16
        nu, pos = rint32(data, pos)
        out += wint16(nu)
        for _ in range(nu):
            un, pos = rpstring(data, pos)
            out += wpstring(un)
            rate, pos = rint8(data, pos)
            out += wint8(rate)

            # Spec order: num_inputs, num_outputs, special_index, [inputs], [outputs]
            ni, pos = rint32(data, pos)
            no, pos = rint32(data, pos)
            si, pos = rint16(data, pos)

            out += wint16(ni)
            out += wint16(no)
            out += wint16(si)

            for _ in range(ni):
                uidx, pos = rint32(data, pos)
                out += wint32(uidx)
                if uidx == -1:
                    cidx, pos = rint32(data, pos)
                    out += wint32(cidx)
                else:
                    oidx, pos = rint32(data, pos)
                    out += wint32(oidx)

            for _ in range(no):
                orate, pos = rint8(data, pos)
                out += wint8(orate)

        # Variants: int16 in both
        nv, pos = rint16(data, pos)
        out += wint16(nv)
        for _ in range(nv):
            vn, pos = rpstring(data, pos)
            out += wpstring(vn)
            for _ in range(np_):
                v, pos = rfloat32(data, pos)
                out += wfloat32(v)

    with open(outp, 'wb') as f:
        f.write(out)
    print(f'Converted: {inp} ({len(data)}b v2) -> {outp} ({len(out)}b v1)')


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('Usage: python3 v2_to_v1.py <input.scsyndef> <output.scsyndef>')
        sys.exit(1)
    convert(sys.argv[1], sys.argv[2])