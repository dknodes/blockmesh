#!/bin/bash

# Color and icon definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'
ICON_TELEGRAM="🚀"
ICON_INSTALL="🛠️"
ICON_LOGS="📄"
ICON_RESTART="🔄"
ICON_STOP="⏹️"
ICON_START="▶️"
ICON_CHANGE_ACCOUNT="🔑"
ICON_EXIT="❌"
ICON_VIEW="👀"

# Draw menu borders and telegram icon
draw_top_border() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${RESET}"
}
draw_middle_border() {
    echo -e "${CYAN}╠══════════════════════════════════════════════════════╣${RESET}"
}
draw_bottom_border() {
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${RESET}"
}
print_telegram_icon() {
    echo -e "          ${MAGENTA}${ICON_TELEGRAM} Follow us on Telegram!${RESET}"
}
display_ascii() {
    echo -e "    ${RED}    ____  __ __    _   ______  ____  ___________${RESET}"
    echo -e "    ${GREEN}   / __ \\/ //_/   / | / / __ \\/ __ \\/ ____/ ___/${RESET}"
    echo -e "    ${BLUE}  / / / / ,<     /  |/ / / / / / / / __/  \\__ \\ ${RESET}"
    echo -e "    ${YELLOW} / /_/ / /| |   / /|  / /_/ / /_/ / /___ ___/ / ${RESET}"
    echo -e "    ${MAGENTA}/_____/_/ |_|  /_/ |_/\____/_____/_____//____/  ${RESET}"
}

# Display main menu
show_menu() {
    clear
    draw_top_border
    display_ascii
    draw_middle_border
    print_telegram_icon
    echo -e "    ${BLUE}Subscribe to our channel: ${YELLOW}https://t.me/dknodes${RESET}"
    draw_middle_border
    echo -e "                ${GREEN}Node Manager for Blockmesh${RESET}"
    echo -e "    ${YELLOW}Please choose an option:${RESET}"
    echo -e "    ${CYAN}1.${RESET} ${ICON_INSTALL}  Install Node"
    echo -e "    ${CYAN}2.${RESET} ${ICON_LOGS} View Logs"
    echo -e "    ${CYAN}3.${RESET} ${ICON_RESTART} Restart Node"
    echo -e "    ${CYAN}4.${RESET} ${ICON_STOP}  Stop Node"
    echo -e "    ${CYAN}5.${RESET} ${ICON_START}  Start Node"
    echo -e "    ${CYAN}6.${RESET} ${ICON_VIEW} View account"
    echo -e "    ${CYAN}7.${RESET} ${ICON_CHANGE_ACCOUNT} Change Account"
    echo -e "    ${CYAN}0.${RESET} ${ICON_EXIT} Exit"
    draw_bottom_border
    echo -ne "${YELLOW}Enter a command number [0-7]:${RESET} "
    read choice
}

# Install node function with registration link and check
install_node() {
    echo -e "${YELLOW}To continue, please register at the following link:${RESET}"
    echo -e "${CYAN}https://app.blockmesh.xyz/register?invite_code=DK${RESET}"
    echo -ne "${YELLOW}Have you completed registration? (y/n): ${RESET}"
    read registered

    if [[ "$registered" != "y" && "$registered" != "Y" ]]; then
        echo -e "${RED}Please complete the registration and use referral code DK to continue.${RESET}"
        read -p "Press Enter to return to the menu..."
        return
    fi

    echo -e "${GREEN}🛠️  Installing node...${RESET}"
    sudo apt update
    if ! command -v docker &> /dev/null; then
        sudo apt install docker.io -y
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
    if ! command -v docker-compose &> /dev/null; then
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    echo -ne "${YELLOW}Enter your email:${RESET} "
    read USER_EMAIL
    echo -ne "${YELLOW}Enter your password:${RESET} "
    read USER_PASSWORD
    echo "USER_EMAIL=${USER_EMAIL}" > .env
    echo "USER_PASSWORD=${USER_PASSWORD}" >> .env
    docker-compose up -d
    echo -e "${GREEN}✅ Node installed successfully. Check the logs to confirm authentication.${RESET}"
    read -p "Press Enter to return to the menu..."
}

# View logs function
view_logs() {
    echo -e "${GREEN}📄 Viewing logs...${RESET}"
    docker-compose logs
    echo
    read -p "Press Enter to return to the menu..."
}

# Restart node function
restart_node() {
    echo -e "${GREEN}🔄 Restarting node...${RESET}"
    docker-compose down
    docker-compose up -d
    echo -e "${GREEN}✅ Node restarted.${RESET}"
    read -p "Press Enter to return to the menu..."
}

# Stop node function
stop_node() {
    echo -e "${GREEN}⏹️ Stopping node...${RESET}"
    docker-compose down
    echo -e "${GREEN}✅ Node stopped.${RESET}"
    read -p "Press Enter to return to the menu..."
}

# Start node function
start_node() {
    echo -e "${GREEN}▶️ Starting node...${RESET}"
    docker-compose up -d
    echo -e "${GREEN}✅ Node started.${RESET}"
    read -p "Press Enter to return to the menu..."
}

# Change account function
change_account() {
    echo -e "${YELLOW}🔑 Changing account details...${RESET}"
    echo -ne "${YELLOW}Enter new email:${RESET} "
    read USER_EMAIL
    echo -ne "${YELLOW}Enter new password:${RESET} "
    read USER_PASSWORD
    echo "USER_EMAIL=${USER_EMAIL}" > .env
    echo "USER_PASSWORD=${USER_PASSWORD}" >> .env
    echo -e "${GREEN}✅ Account details updated successfully.${RESET}"
    read -p "Press Enter to return to the menu..."
}

сat_account(){
    cat .env
    read -p "Press Enter to return to the menu..."
}

# Main menu loop
while true; do
    show_menu
    case $choice in
        1)
            install_node
            ;;
        2)
            view_logs
            ;;
        3)
            restart_node
            ;;
        4)
            stop_node
            ;;
        5)
            start_node
            ;;
        6)
            сat_account
            ;;
        7)
            change_account
            ;;
        0)
            echo -e "${GREEN}❌ Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid input. Please try again.${RESET}"
            read -p "Press Enter to continue..."
            ;;
    esac
done
