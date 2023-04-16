import numpy as np
cimport numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
cimport cython
from libc.stdlib cimport rand, srand, RAND_MAX
from libc.time cimport time
import time as T
# Game of Life
srand(time(NULL))
# Function to generate random grid.
cdef random_grid(int N):
    cdef np.ndarray res = np.zeros((N,N), dtype = np.intc)
    cdef int[:, ::1] res_view = res
    cdef int i, j
    for i in range(N):
        for j in range(N):
            if rand() < 0.6*(RAND_MAX + 1):
                res_view[i, j] = 1
            else:
                res_view[i, j] = 0
    return res_view
# C function to calculate the neighbours total.
cdef int neigh(int[:, ::1] grid, int i, int j, int N):
    cdef int total = 0, ii, jj, dx, dy
    for ii in range(-1,2):
        for jj in range(-1,2):
            if ii == 0 and jj == 0:
                continue
            else:
                dx = i + ii
                dy = j + jj
                if dx >= 0 and dx < N and dy >= 0 and dy < N:
                    total += grid[dx, dy]
    return total
# Function to calculate the next iteration.
@cython.boundscheck(False)
@cython.wraparound(False)
def run(int frame_num, img, int[:, ::1] grid, int N):
    cdef int i, j, total
    cdef np.ndarray tmp = np.zeros(shape = (N, N), dtype = np.intc)
    cdef int[:, ::1] tmp_view = tmp
    cdef int[:, ::1] grid_view = grid
    start = T.time()
    for i in range(N):
        for j in range(N):
            total = neigh(grid_view, i, j, N)
            if grid_view[i, j] == 1:
                if total < 2 or total > 3:
                    tmp_view[i, j] = 0
                elif total == 2 or total == 3:
                    tmp_view[i, j] = 1
            else:
                if total == 3:
                    tmp_view[i, j] = 1
    img.set_data(tmp_view)
    grid_view[:, :] = tmp_view[:, :]
    end = T.time()
    print(end - start)
    return img
# Animation function.
def main():
    cdef int N = 1000
    grid = random_grid(N)
    fig, ax = plt.subplots()
    ax.set_yticklabels([])
    ax.set_xticklabels([])
    img = ax.imshow(grid, interpolation = 'nearest')
    ani = animation.FuncAnimation(fig, run, fargs=(img, grid, N, ), frames = 10, interval = 50, save_count = 50)
    plt.show()
if __name__ == '__main__':
    main()
