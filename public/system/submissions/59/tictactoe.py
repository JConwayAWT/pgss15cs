#Maria Cioffi
#PGSS TIC-TAC-TOE

import copy

seen_data = []
seen_data_minimax_values = []

class Struct(): pass

class Board:
    """basic tic-tac-toe game
    """

    def __init__(self, parent = None):
        """ Construct TTT
        """
        self.data = [[' ']*3 for row in range(3)]

    def __str__(self):
        """text representation of the board
        """
        b = '-------\n'
        for i in range(3):
            b+='|'
            for j in range(3):
                b+= self.data[i][j] + '|'
            b+='\n-------\n'
        return b

    def getBoard(self):
        """get the 2D array of data
        """
        return self.data

    def move(self, row, col, mark):
        """If the chosen position is open and the row and col
            are within range, places the mark in the 2Darray at [row][col]
        """
        if (row in range(3) and col in range(3)):
            if (self.data[row][col] == " "):
                if (mark == "X"):
                    self.data[row][col] = "X"
                elif (mark == "O"):
                    self.data[row][col] = "O"
                return True
            else:
                print("This spot is taken, choose again")
                return False
        print("col or row not in range, choose again")
        return False

    def isTie(self, board):
        """returns true if the board is full and false if otherwise
        """
        for i in range(3):
            for j in  range(3):
                if (board[i][j] == " "):
                    return False
        #print("It's a Tie")
        return True

    def isWinFor(self, board, mark):
        """returns true if "mark" has won the game and false otherwise
        """
        rowWin = 0
        colWin = 0
        for i in range(3):
            rowWin = 0
            colWin = 0
            for j in range(3):
                if (board[i][j] == mark):
                    rowWin +=1
                if (board[j][i] == mark):
                    colWin +=1
            if (colWin == 3 or rowWin == 3):
                #print(self)
                #print(mark + " wins!")
                return True
        if (board[0][0] == board[1][1] == board[2][2] == mark):
           #print(self)
           #print(mark + " wins!")
           return True
        if (board[0][2] == board[1][1] == board[2][0] == mark):
            #print(self)
            #print(mark + " wins!")
            return True
        return False

    def compareBoards(self, other):
        """A method to check if self has an equivalent board to "other",
            returns true if all marks are in equivalent positions, otherwise false.
        """
        for row in range(3):
            for col in range(3):
                if self.data[row][col] != other.getBoard()[row][col]:
                    return False
        return True

    def newMark(self, mark):
        """returns an X if input "mark" was O, returns O otherwise
        """
        if mark == "X":
            return "O"
        return "X"


    def playTTT(self):
        """plays interactive Tic-Tac-Toe in the shell with our board
        """
        currentMark = "X"
        print("Welcome to Tic-Tac-Toe!")
        while(True):
                print(self)
                while(True):
                    #try:
                        if currentMark == "X":
                          row = int(input("Enter a row (0, 1, or 2): "))
                          col = int(input("Enter a col (0, 1, or 2): "))
                        else:
                          row, col = self.get_ai_move()
                        if(self.move(row,col, currentMark)):
                            break
                    #except:
                    #    print("Enter a valid row and column")
                if (self.isWinFor(self.data, currentMark)):
                    print(self)
                    print currentMark + " wins!"
                    break
                elif self.isTie(self.data):
                  print(self)
                  print "It's a tie!"
                  break
                currentMark = self.newMark(currentMark)

    def make_ttt_state(self, data, parent, move, belongs_to_o, value):
      state = Struct()
      state.data = data
      state.parent = parent
      state.move = move
      state.belongs_to_o = belongs_to_o
      state.value = value
      return state

    def get_children_of(self, state):
      data = state.data
      children = []
      for x in range(3):
        for y in range(3):
          data_copy = copy.deepcopy(data)
          if data_copy[x][y] == " ":
            if state.belongs_to_o:
              data_copy[x][y] = "O"
            else:
              data_copy[x][y] = "X"
            if self.isWinFor(data_copy, "O"):
              val = 1
            elif self.isWinFor(data_copy, "X"):
              val = -1
            elif self.isTie(data_copy):
              val = 0
            else:
              val = None
            new_state = self.make_ttt_state(data_copy, state, (x, y), not state.belongs_to_o, val)
            children.append(new_state)
      return children

    def get_ai_move(self):
      current_board = self.getBoard()
      current_state = self.make_ttt_state(current_board, None, None, True, 0)
      best_child = self.get_minimax_move(current_state)
      return best_child.move

    def get_minimax_move(self, state):
      minimax_values = []
      children = self.get_children_of(state)

      for child in children:
        if child.data in seen_data:
          minimax_values.append(seen_data_minimax_values[seen_data.index(child.data)])
        elif self.isWinFor(child.data, "O"):
          minimax_values.append(1)
          seen_data.append(child.data)
          seen_data_minimax_values.append(1)
        elif self.isWinFor(child.data, "X"):
          minimax_values.append(-1)
          seen_data.append(child.data)
          seen_data_minimax_values.append(-1)
        elif self.isTie(child.data):
          minimax_values.append(0)
          seen_data.append(child.data)
          seen_data_minimax_values.append(0)
        else:
          value = self.get_minimax_move(child)
          minimax_values.append(value)
          seen_data.append(child.data)
          seen_data_minimax_values.append(value)


      if state.parent == None:
        return children[minimax_values.index(max(minimax_values))]

      if state.belongs_to_o:
        return max(minimax_values)
      else:
        return min(minimax_values)

b = Board()
b.playTTT()