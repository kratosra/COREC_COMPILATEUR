# Répertoires
SRC_DIR      = src
INC_DIR      = include
OBJ_DIR      = obj
BIN_DIR      = bin

# Fichiers sources
BISON_FILE   = $(SRC_DIR)/corec.y
FLEX_FILE    = $(SRC_DIR)/corec.l
SYMTABLE_SRC = $(SRC_DIR)/symtab.c
TREESYN_SRC  = $(SRC_DIR)/treesyn.c
DEPENDENCY_SRC = $(SRC_DIR)/dependency.c
MIPS_SRC     = $(SRC_DIR)/mips.c


# Fichiers générés par Bison et Flex
BISON_OUTPUT_C  = $(SRC_DIR)/corec.tab.c
BISON_OUTPUT_H  = $(INC_DIR)/corec.tab.h
FLEX_OUTPUT_C   = $(SRC_DIR)/lex.yy.c

# Objets à compiler
OBJS = $(OBJ_DIR)/corec.tab.o $(OBJ_DIR)/lex.yy.o \
       $(OBJ_DIR)/symtab.o $(OBJ_DIR)/treesyn.o \
       $(OBJ_DIR)/dependency.o $(OBJ_DIR)/mips.o\
       

# Compilateur et options
CC      = gcc
CFLAGS  = -Wextra -g -I$(INC_DIR)
LDFLAGS = -lfl

# Règle par défaut
all: $(BIN_DIR)/corec

# Création de l'exécutable
$(BIN_DIR)/corec: $(OBJS) | $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# Génération des sources avec Bison
$(SRC_DIR)/corec.tab.c $(INC_DIR)/corec.tab.h: $(BISON_FILE)
	bison -d -v -o $(SRC_DIR)/corec.tab.c $<

# Génération du scanner avec Flex (dépend de la sortie de Bison)
$(SRC_DIR)/lex.yy.c: $(FLEX_FILE) $(INC_DIR)/corec.tab.h
	flex -o $@ $<

# Compilation des fichiers C en objets
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Création des répertoires nécessaires
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Nettoyage
clean:
	rm -rf $(BIN_DIR) $(OBJ_DIR) $(SRC_DIR)/corec.tab.* $(SRC_DIR)/lex.yy.c *.output

.PHONY: all clean

