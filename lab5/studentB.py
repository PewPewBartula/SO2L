import random

def is_player_starting():

    result = bool(random.getrandbits(1))
    return result

def get_user_move(board):

    inp = input("What's your move (insert coordinates)")

    try:
        move = tuple(int(x) for x in inp.split())
    except(ValueError):
        print("Error: Inavlid input")
        return

    if board[move[0]][move[1]] != " ":
        print("Unable to perform move")
        return
    else:
        board[move[0]][move[1]] = "X"
        return board

def ai_move(board):
   
    move_is_ok = False

    while not move_is_ok:

        x = random.randint(0, 4)
        y = random.randint(0, 4)

        if board[x][y] == " ":
            board[x][y] == "O"
            move_is_ok = True
 
    return board

def annouce_outcome(board, players_move):

    is_there_a_winner = False

    for x in range(5):
        for y in range(5):
            if board[x][y] == " ":
                is_there_a_winner = True
                break

    if is_there_a_winner:
        winner = ""
        if players_move:
            winner = "computer"
        else:
            winner = "user"
        print(f"The winner is {winner}")
        return
    print("There is no winner")
