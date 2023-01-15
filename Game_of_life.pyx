import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import cython
from tkinter import *
from tkinter import ttk
import time

class Game_of_life(Tk):
    # Constructor.
    def __init__(self, *args, **kwargs):
        Tk.__init__(self, *args, **kwargs)
        self.n = 500
        self.grid = self.random_grid()
        self.cells = {}
        self.run = True

        self.title("Conway's Game of Life")
        self.content = ttk.Frame(self, padding=(5))
        self.content.grid(row =0, column=0, sticky=(N,S,E,W))

        self.canvas = Canvas(self.content, width = 1000, height = 1000, borderwidth = 0, highlightthickness = 0, background = 'white')
        self.canvas.grid(row=0, column=0, sticky=(N,S,E,W))
        self.canvas.bind('<Configure>', self.draw)

        self.controls = ttk.Frame(self.content, padding=(5))
        self.controls.grid(row=1, column=0, sticky=(N,S,E,W))
        self.start = ttk.Button(self.controls, text='Start', command=self.start_game)
        self.start.grid(row=0, column=0, sticky=(W))
        self.stop = ttk.Button(self.controls, text='Stop', command=self.stop_game)
        self.stop.grid(row=0, column=2, sticky=(E))
        self.random = ttk.Button(self.controls, text='random', command=self.randgen)
        self.random.grid(row=0, column=1, sticky=(E,W))
        
        
    # Constructs a random grid.
    def random_grid(self):
        return np.random.choice([-1,1], self.m*self.n, p = [0.3, 0.7]).reshape(self.m*self.n)
    # Function to compute the next cycle.
    def cycle(self, img):
        cdef int i = 0
        cdef int j = 0
        cdef int total
        new_grid = self.grid.copy()
        for i in range(self.width):
            for j in range(self.height):
                total = self.grid[i, (j+1)%self.n] + self.grid[i, (j-1)%self.n] + self.grid[(i-1)%self.m, j] + self.grid[(i+1)%self.m, j] + self.grid[(i+1)%self.m, (j+1)%self.n] + self.grid[(i-1)%self.m, (j+1)%self.n] + self.grid[(i-1)%self.m, (j-1)%self.n] + self.grid[(i+1)%self.m, (j-1)%self.n]
                if self.grid[i,j] == 1:
                    if total < 2 or total > 3:
                        self.grid[i,j] = 1
                else:
                    if total == 3:
                        self.grid[i,j] = 1
        img.set_data(new_grid)
        self.grid[:] = new_grid[:]
        return img
    
