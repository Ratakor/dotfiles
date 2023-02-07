//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/				/*Update Interval*/	/*Update Signal*/
	{" ", "db_tempcpu",				10,					0},
	{"ﳔ ", "db_memory",					10,					0},
	{" ", "db_battery",				5,                  0},
	{" ", "db_wifi",					5,					0},
	//{" ", "db_eth",					5,					0},
	{" ", "db_volume",					0,					10},
	{" ", "db_date",					3600,				0},
	{" ", "db_time",					1,					0},
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
