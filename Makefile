
NAME = cub4D

SRC =	$(wildcard main.c src/*.c src/*/*.c src/*/*/*.c src/*/*/*/*.c src/*/*/*/*/*.c)

RM = rm -rf

CFLAGS = -Werror -Wall -Wextra

OBJ_DIR = obj
SRC_DIR = src
INC_DIR = inc

OBJS = $(SRC:%.c=$(OBJ_DIR)/%.o)

CC = gcc #-g -fsanitize=address 

LIBFTDIR = ./inc/libft

LIBFTA = $(LIBFTDIR)/libft.a


# Detect the operating system
UNAME_S := $(shell uname -s)

# macOS
ifeq ($(UNAME_S),Darwin)
MLX_DIR = ./mlx
MLX = $(MLX_DIR)/libmlx.a
LINK = -L$(MLX_DIR) -lmlx -framework OpenGL -framework AppKit

# Linux
else
MLX_DIR = ./minilibx-linux
MLX = $(MLX_DIR)/libmlx.a
LINK = -L$(MLX_DIR) -lmlx -lX11 -lXext -lm
endif
# endif marks the end of a conditional block in a Makefile

NONE='\033[0m'
GREEN='\033[32m'
GRAY='\033[2;37m'
CURSIVE='\033[3m'
WARNING='\033[33m'

all: $(NAME)

$(NAME): $(LIBFTA) $(MLX) $(SRC) $(OBJS)
	@$(CC) $(OBJS) $(LIBFTA) $(LINK) -o $@
	@echo $(GREEN)"- Compiled -"$(NONE)

$(OBJ_DIR)/%.o: %.c $(LIBFTA)
	@echo $(CURSIVE)$(GRAY) "     - Building $<" $(NONE)
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -Imlx -c $< -o $@

$(MLX):
	@echo $(CURSIVE)$(GRAY) "     - (Wait a sec...) Building $@" $(NONE)
	@make -C $(MLX_DIR) > /dev/null 2>&1 || true

$(LIBFTA):
	@echo $(CURSIVE)$(GRAY) "     - (Wait a sec...) Building $@" $(NONE)
	@make all -C $(LIBFTDIR) > /dev/null 2>&1 || true

clean:
	@$(RM) $(OBJS) $(OBJ_DIR)
	@make -C $(LIBFTDIR) clean > /dev/null 2>&1 || true
	@make -C $(MLX_DIR) clean > /dev/null 2>&1 || true
	@echo $(CURSIVE)$(GRAY) "     - Object files removed" $(NONE)

fclean: clean
	@rm -f $(NAME) > /dev/null 2>&1 || true
	@make -C $(LIBFTDIR) fclean > /dev/null 2>&1 || true
	@echo $(CURSIVE)$(GRAY) "     - $(NAME) removed" $(NONE)

re: fclean all

.PHONY: all clean fclean re
