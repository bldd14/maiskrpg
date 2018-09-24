new Handle;

#include <YSI\y_hooks>

#define 	MySQL_Host  	"localhost"
#define 	MySQL_User 		"root"
#define 	MySQL_Pass 		""
#define 	MySQL_DB 		"sampdb"

hook OnGameModeInit(){
	Handle = mysql_connect(MySQL_Host, MySQL_User, MySQL_DB, MySQL_Pass);
	return 1;
}