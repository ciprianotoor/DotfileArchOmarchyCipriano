# =====================================================
# Midnight Commander SSH Menu
# =====================================================

function mc-menu() {

    clear

    echo "═══════════════════════════════════════════════════════"
    echo "              MIDNIGHT COMMANDER SSH"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo " [1] Windows 11 LTSC - cipriano"
    echo " [2] Windows 11 LTSC - root"
    echo ""
    echo " [3] Proxmox - cipriano"
    echo " [4] Proxmox - cipriano <-> C:\Users\cipriano"
    echo ""
    echo " [5] Windows LTSC (cipriano) <-> C:\Users\cipriano"
    echo " [6] Windows LTSC (root)     <-> C:\Users\cipriano"
    echo ""
    echo " [0] Salir"
    echo ""

    read "opcion?Seleccione una opción: "

    case $opcion in

        1)
            mc -S dark sh://cipriano@192.168.1.50:1984/
            ;;

        2)
            mc -S dark sh://root@192.168.1.50:1984/
            ;;

        3)
            mc -S dark sh://cipriano@192.168.1.17:1984/
            ;;

        4)
            mc -S dark sh://cipriano@192.168.1.17:1984/ C:\\Users\\cipriano
            ;;

        5)
            mc -S dark sh://cipriano@192.168.1.50:1984/ C:\\Users\\cipriano
            ;;

        6)
            mc -S dark sh://root@192.168.1.50:1984/ C:\\Users\\cipriano
            ;;

        0)
            return
            ;;

        *)
            echo "\nOpción no válida."
            ;;
    esac
}
