#!/bin/bash

# ----- Language Setup -----
set_language() {
    clear
    echo -e "\033[1;36m"
    echo "  _______________________________________________________"
    echo " |                                                       |"
    echo " |                   Select Language / اختر اللغة        |"
    echo " |_______________________________________________________|"
    echo " |                                                       |"
    echo " |   1) English                                          |"
    echo " |   2) العربية                                         |"
    echo " |_______________________________________________________|"
    echo -e "\033[0m"

    read -p "Choose/اختر (1/2): " lang_choice
    case $lang_choice in
        1) LANG="en";;
        2) LANG="ar";;
        *) echo -e "\033[1;31mInvalid input!/اختيار خاطئ\033[0m"; exit 1;;
    esac
}

# ----- Texts (Multi-language) -----
texts() {
    if [[ $LANG == "en" ]]; then
        # English Texts
        MENU_TITLE="Kali Linux Ultimate Tool"
        MENU_OPTIONS=("Install Kali Linux" "Install Oh-My-Zsh" "Start Kali" "Exit")
        PROGRESS_MSG="Installing, please wait..."
        SUCCESS_MSG="Installation completed successfully!"
        EXIT_MSG="Goodbye! 👋"
    else
        # Arabic Texts
        MENU_TITLE="أداة كالي لينكس المتكاملة"
        MENU_OPTIONS=("تثبيت كالي لينكس" "تثبيت Oh-My-Zsh" "تشغيل كالي" "خروج")
        PROGRESS_MSG="جاري التثبيت، انتظر..."
        SUCCESS_MSG="تم التثبيت بنجاح!"
        EXIT_MSG="مع السلامة! 👋"
    fi
}

# ----- Progress Bar (Fancy) -----
show_progress() {
    echo -ne "${BLUE}["
    while :; do
        for c in ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏; do
            echo -ne "\r${BLUE}[${GREEN}$c${BLUE}] ${PROGRESS_MSG}"
            sleep 0.1
        done
    done
}

# ----- Main Menu -----
show_menu() {
    clear
    echo -e "${CYAN}"
    echo "  _______________________________________________________"
    echo " |                                                       |"
    echo " |    ${RED}***** ${YELLOW}$MENU_TITLE ${RED}*****${CYAN}            |"
    echo " |_______________________________________________________|"
    echo " |                                                       |"
    for i in "${!MENU_OPTIONS[@]}"; do
        printf " |   ${GREEN}$((i+1))) ${MENU_OPTIONS[i]}%-$((30-${#MENU_OPTIONS[i]}))s ${CYAN}|\n"
    done
    echo " |_______________________________________________________|"
    echo -e "${NC}"
}

# ----- Core Functions -----
install_kali() {
    { 
        proot-distro install kali-linux && \
        proot-distro login kali-linux -- apt update && \
        proot-distro login kali-linux -- apt upgrade -y 
    } > /dev/null 2>&1 &
    
    local pid=$!
    show_progress "$pid"
    wait $pid
    echo -e "\n${GREEN}[✓] $SUCCESS_MSG${NC}"
}

install_ohmyzsh() {
    { 
        pkg install -y zsh git curl && \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    } > /dev/null 2>&1 &
    
    local pid=$!
    show_progress "$pid"
    wait $pid
    echo -e "\n${GREEN}[✓] $SUCCESS_MSG${NC}"
}

# ----- Main Execution -----
set_language
texts

while true; do
    show_menu
    read -p "$([ "$LANG" == "en" ] && echo "Choose option" || echo "اختر خيارًا"): " choice
    
    case $choice in
        1) install_kali ;;
        2) install_ohmyzsh ;;
        3) proot-distro login kali-linux ;;
        4) echo -e "${RED}[+] $EXIT_MSG${NC}"; exit 0 ;;
        *) echo -e "${RED}[!] $([ "$LANG" == "en" ] && echo "Invalid choice" || echo "اختيار خاطئ")${NC}" ;;
    esac
    
    read -p "$([ "$LANG" == "en" ] && echo "Press Enter to continue" || echo "اضغط إنتر للمتابعة")..."
done
