INSTALL_DIR=~/.local/bin

all:
	@echo "run 'make install'"


install:
	@echo ""
	mkdir -p $(INSTALL_DIR)
	cp bookmark.sh $(INSTALL_DIR)
	@echo ""
	@echo "add 'source $(INSTALL_DIR)/bookmark.sh' to your .bashrc/.zshrc"
	@echo ''
	@echo 'USAGE:'
	@echo '------'
	@echo 'b  - Bookmark list'
	@echo 'a  - Add the current directory to bookmark'
	@echo 't <bookmark_index>  - Goes (cd) to the directory associated with "bookmark_index"'
	@echo 'r <bookmark_index> ...  - Deletes the bookmark with index'
	@echo 'c - Deletes all bookmark'
	@echo ""
