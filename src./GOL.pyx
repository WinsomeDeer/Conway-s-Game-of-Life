import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
cimport cython
import time
# Game of Life
# Function to generate random grid.
def random_grid(N):
    res = np.random.choice([0,1], N*N, p = [0.6,0.4]).reshape(N, N)
    cdef int[:,:] res_view = res
    return res_view
# C function to calculate the neighbours total.
@cython.boundscheck(False)
@cython.wraparound(False)
cdef int neigh(int[:,::1] grid, int i, int j, int N):
    cdef int total = 0, ii, dx, dy
    cdef list dr = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    for ii in range(8):
        dx = i + dr[ii][0]
        dy = j + dr[ii][1]
        if dx >= 0 and dx < N and dy >= 0 and dy < N:
            total += grid[dx][dy]
    return total
# Function to calculate the next iteration.
@cython.boundscheck(False)
@cython.wraparound(False)
def run(int frame_num, img, int[:, ::1] grid, int N):
    cdef int i, j, total
    tmp = np.zeros(shape = (N, N), dtype = np.intc)
    cdef int[:, :] tmp_view = tmp
    cdef int[:, ::1] grid_view = grid
    start = time.time()
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
    grid_view[:, :] = tmp_view[:,:]
    end = time.time()
    print(end - start)
    return img
# Animation function.
def main():
    cdef int N
    N = 100
    grid = random_grid(N)
    fig, ax = plt.subplots()
    ax.set_yticklabels([])
    ax.set_xticklabels([])
    img = ax.imshow(grid, interpolation = 'nearest')
    ani = animation.FuncAnimation(fig, run, fargs=(img, grid, N, ), frames = 10, interval = 50, save_count = 50)
    plt.show()

if __name__ == '__main__':
    main()
