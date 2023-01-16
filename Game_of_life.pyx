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
        self.a = np.zeros((self.n, self.n))#array with cell information
        self.b = np.zeros((self.n, self.n))
        #self.grid = self.random_grid()
        self.cells = {}
        self.run = True

        self.title("Conway's Game of Life")
        self.content = ttk.Frame(self, padding=(5))
        self.content.grid(row =0, column=0, sticky=(N,S,E,W))

        self.canvas = Canvas(self.content, width = 1000, height = 1000, borderwidth = 0, highlightthickness = 0, background = 'white')
        self.canvas.grid(row=0, column=0, sticky=(N,S,E,W))
        self.canvas.bind('<Configure>', self.draw)

        self.controls = ttk.Frame(self.content, padding = (5))
        self.controls.grid(row=1, column=0, sticky=(N,S,E,W))
        self.start = ttk.Button(self.controls, text='Start', command = self.start_game())
        self.start.grid(row=0, column=0, sticky=(W))
        self.stop = ttk.Button(self.controls, text='Stop', command = self.stop_game())
        self.stop.grid(row=0, column=2, sticky=(E))
        self.random = ttk.Button(self.controls, text='Random', command = self.random_grid())
        self.random.grid(row=0, column=1, sticky=(E,W))

        self.columnconfigure(0, weight=1)
        self.rowconfigure(0, weight=1)
        self.content.columnconfigure(0, weight=1)
        self.content.rowconfigure(0, weight=4)
        self.content.rowconfigure(1, weight=1)
        self.controls.columnconfigure(0,weight=1)
        self.controls.columnconfigure(1,weight=1)
        self.controls.columnconfigure(2,weight=1)
        self.controls.rowconfigure(0,weight=1)

    def draw(self, event = None):
    #Draws the grid with the cells
        self.canvas.delete('rect')
        cdef int width
        cdef int height
        width = int(self.canvas.winfo_width()/self.n)
        height = int(self.canvas.winfo_height()/self.n)
        cdef int x1
        cdef int x2
        cdef int y1
        cdef int y2
        for col in range(self.n):
            for row in range(self.n):
                x1 = col*width
                x2 = x1 + width
                y1 = row*height
                y2 = y1 + height
                if self.a[row][col] == 0:
                    cell = self.canvas.create_rectangle(x1, y1, x2, y2,
                            fill='white', tags='cell')
                else:
                    cell = self.canvas.create_rectangle(x1, y1, x2, y2,
                            fill='black', tags='cell')
                self.cells[row, col] = cell
                self.canvas.tag_bind(cell, '<Button-1>', lambda event,
                        row=row, col=col: self.click(row, col))

    def click(self, row, col):
        cell = self.cells[row,col]
        color = 'white' if self.a[row, col] == 1. else 'black'
        if self.a[row,col] == 0:
            self.a[row, col]=1
        else:
            self.a[row,col]=0
        self.canvas.itemconfigure(cell, fill=color)

    # Constructs a random grid.
    def random_grid(self):
        return np.random.choice([-1,1], self.n*self.n, p = [0.3, 0.7]).reshape(self.n*self.n)
    # Function to compute the next cycle.
    def cycle(self):
        self.draw()
        time.sleep(.1)
        cdef int i
        cdef int j
        cdef int total
        if self.running:
            for i in range(self.n):
                for j in range(self.n):
                    total = self.a[i, (j+1)%self.n] + self.a[i, (j-1)%self.n] + self.a[(i-1)%self.n, j] + self.a[(i+1)%self.n, j] + self.a[(i+1)%self.n, (j+1)%self.n] + self.a[(i-1)%self.n, (j+1)%self.n] + self.a[(i-1)%self.n, (j-1)%self.n] + self.a[(i+1)%self.n, (j-1)%self.n]
                    if self.b[i,j] == 1:
                        if total < 2 or total > 3:
                            self.b[i,j] = 1
                    else:
                        if total == 3:
                            self.b[i,j] = 1
            self.a = self.b
            self.b = np.zeros((self.n,self.n))
            self.after(1, self.cycle())          


    def start_game(self):
        #Changes the value of running and calls game()
        self.running = True
        self.cycle()

    def stop_game(self):
        #changes the value of runnung to stop game()'s loop
        self.running = False

if __name__ == '__main__':
    gameoflife = Game_of_life()
    gameoflife.mainloop()    
    
