from os import walk, getuid, cpu_count
from os.path import join
from sys import stderr, exit
from hashlib import sha256
from threading import Thread
from queue import Queue

CHUNK_SIZE = 0x100000 * 8

q = Queue()
sizes = []


def gethash(path: str):
    hasher = sha256()
    totallen = 0
    with open(path, 'rb') as f:
        while data := f.read(CHUNK_SIZE):
            hasher.update(data)
            totallen += len(data)
    return hasher.digest(), totallen


def processfiles():
    while item := q.get():
        #print('Getting', file=stderr)
        upper, lower = item
        #print('Hashing', lower, file=stderr)
        q.task_done()
        try:
            upperhash, upperlen = gethash(upper)
            lowerhash, lowerlen = gethash(lower)
        except (FileNotFoundError, OSError):
            pass #print('Could not find one of the files!', file=stderr)
        else:
            if upperhash == lowerhash:
                # due to threading, the end may be printed at a different time, causing formatting issues
                print(lower[1:] + '', end='\n')
                sizes.append(lowerlen)
            else:
                pass #print('Identical:', lower, file=stderr)


def dowalk(walkpath):
    for root, dirs, files in walk(walkpath):
        realroot = root[root.find('/'):]
        for f in files:
            upper = join(root, f)
            lower = join(realroot, f)
            q.put((upper, lower))


if __name__ == '__main__':
    if getuid() != 0:
        print("This may not work unless you run it as root.", file=stderr)
        exit(1)

    threads = []
    for x in range(cpu_count()):
        t = Thread(target=processfiles)
        print(t, file=stderr)
        t.start()
        threads.append(t)

    dowalk('upper-dirs/usr')
    dowalk('upper-dirs/opt')

    print(q.qsize())
    q.join()
    print('Joined queue', file=stderr)

    for t in threads:
        q.put(None)

    for t in threads:
        print('Joining', t, file=stderr)
        t.join()

    totalsize = sum(sizes)
    print('Total size in dupes:', totalsize, 'bytes or', totalsize / 0x100000, 'MiB', file=stderr)
