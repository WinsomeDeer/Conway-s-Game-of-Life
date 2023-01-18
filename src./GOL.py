import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Game of Life
# Function to generate random grid.
def random_grid(N):
    return np.random.choice([0,1], N*N, p = [0.6,0.4]).reshape(N, N)
# Function to calculate the next iteration.    
def run(frame_num, img, grid, N):
    tmp = np.zeros(shape = (N, N))
    for i in range(N):
        for j in range(N):
            total = int(grid[i%N][(j+1)%N] + grid[i%N][(j-1)%N]
                        + grid[(i-1)%N][j%N] + grid[(i+1)%N][j%N] 
                            + grid[(i+1)%N][(j+1)%N] + grid[(i-1)%N][(j+1)%N] 
                                + grid[(i-1)%N][(j-1)%N] + grid[(i+1)%N][(j-1)%N])
            if grid[i][j] == 1:
                if total < 2 or total > 3:
                    tmp[i][j] = 0
                elif total == 2 or total == 3:
                    tmp[i][j] = 1
            else:
                if total == 3:
                    tmp[i][j] = 1
    img.set_data(tmp)
    grid[:] = tmp[:]
    return img
# Animation function.
def main():
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

