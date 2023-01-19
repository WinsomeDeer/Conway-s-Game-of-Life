import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
cimport cython
# Game of Life
# Function to generate random grid.
def random_grid(N):
    res = np.random.choice([0,1], N*N, p = [0.6,0.4]).reshape(N, N)
    cdef int[:,:] res_view = np.random.choice([0,1], N*N, p = [0.6,0.4]).reshape(N, N)
    return res_view
# Function to calculate the next iteration.    
def run(int frame_num, img, int[:, ::1] grid, int N):
    cdef int i, j, total
    tmp = np.zeros(shape = (N, N), dtype = np.intc)
    cdef int[:, :] tmp_view = tmp
    for i in range(N):
        for j in range(N):
            total = int(grid[i%N][(j+1)%N] + grid[i%N][(j-1)%N]
                        + grid[(i-1)%N][j%N] + grid[(i+1)%N][j%N] 
                            + grid[(i+1)%N][(j+1)%N] + grid[(i-1)%N][(j+1)%N] 
                                + grid[(i-1)%N][(j-1)%N] + grid[(i+1)%N][(j-1)%N])
            if grid[i][j] == 1:
                if total < 2 or total > 3:
                    tmp_view[i][j] = 0
                elif total == 2 or total == 3:
                    tmp_view[i][j] = 1
            else:
                if total == 3:
                    tmp_view[i][j] = 1
    img.set_data(tmp)
    grid[:, :] = tmp_view[:,:]
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
