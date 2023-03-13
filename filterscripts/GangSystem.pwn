#include <a_samp>
#include <MXini>
#include <file>
#include <mSelection>

new skinlist = mS_INVALID_LISTID;

#define MAX_GANGS 500

new
tgang[MAX_PLAYERS],
name[MAX_GANGS][256],
col[MAX_GANGS][256],
gangskin[MAX_PLAYERS],
id[MAX_PLAYERS] = -1
;


new
GangName[MAX_GANGS][256],
Gang[MAX_GANGS],
GangLvl[MAX_PLAYERS],
grname[MAX_GANGS][256],
GColor[MAX_GANGS][10],
PGang[MAX_PLAYERS],
Float:GSpawnX[MAX_GANGS],
Float:GSpawnY[MAX_GANGS],
Float:GSpawnZ[MAX_GANGS],
GSkin[MAX_GANGS][7]
;


public OnFilterScriptInit()
{
    GangLoad();
    skinlist = LoadModelSelectionMenu("mSelection/skins.txt");
	print("\n--------------------------------------");
	print("  Blodhamer Gangs Loaded !              ");
	print("  By FaSTL : faiik_3gps !               ");
	print("--------------------------------------\n");
	return true;
}

public OnFilterScriptExit()
{
    for(new i; i<MAX_PLAYERS; i++) SaveAccount(i);
	return true;
}

public OnPlayerDisconnect(playerid, reason)
{
    SaveAccount(playerid);
	return true;
}

public OnPlayerRequestClass(playerid, classid)
{
    PGang[playerid] = 0;
    GangLvl[playerid] = 0;
    LoadAccount(playerid);
	return true;
}

public OnPlayerSpawn(playerid)
{
	SetTimerEx("Spawn", 500, false, "i", playerid);
	return true;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if(killerid != INVALID_PLAYER_ID) SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
	return true;
}

public OnPlayerText(playerid, text[])
{
	new string[256],string2[256];
	if(PGang[playerid] > 0)
	{
	    GetPlayerColor(playerid);
		format(string, sizeof(string), "[Банда: %s ] %s{00FD00}[ID: %d]{FFFFFF}: %s",grname[PGang[playerid]], PlayerName(playerid), playerid, text);
		format(string2, sizeof(string2), "[Банда: %s ] %s[ID: %d]: %s",grname[PGang[playerid]], PlayerName(playerid), playerid, text);
		printf("%s", string2);
		SendClientMessageToAll(GetPlayerColor(playerid), string);
	    return false;
	}
	return true;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256], idx;
	cmd = strtok(cmdtext,idx);
	if(strcmp(cmd, "/gang", true) == 0)
	{
		ShowPlayerDialog(playerid, 12000, DIALOG_STYLE_LIST, "{0077FF}Blodhamer Drift :{ffffff} Групировки", "\
		>> [1] Создать банду\
		\n>> [2] Управление игроками банды\
		\n>> [3] Редактор банды\
		\n>> {ff0000}Уйти из банды\
		", ">>", "X");
		return true;
 	}
 	
	return false;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new string[256];
	if(dialogid == 12000)
	{
	    if(response)
	    {
		    switch(listitem)
		    {
		        case 0:
		        {
		            if(PGang[playerid] == 0 && GetPlayerScore(playerid) >= 500000 && GetPlayerMoney(playerid) >= 0)
					{
	                	ShowPlayerDialog(playerid, 12001, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Create", "Введите название банды:", ">>", "X");
	                }else return SendClientMessage(playerid, 0xFF0000FF, "Что бы создать банду, вам понадобится 100.000 Score и 2.000.000 Money.");
		        }
		        case 1:
		        {
		            if(PGang[playerid] != 0 && GangLvl[playerid] == 6)
					{
	                	ShowPlayerDialog(playerid, 12005, DIALOG_STYLE_LIST, "{0077FF}Blodhamer Drift :{ffffff} Управление игроками", ">> [1] Назначить скины\n>> [2] Назначить ранг\n>> [3] Пригласить в банду\n>> [4] Кикнуть из банды", ">>", "X");
	                }else return SendClientMessage(playerid, 0xFF0000FF, "Вы должны состоять в банде, и у вас должен быть ранг лидера.");
		        }
		        case 2:
		        {
					if(PGang[playerid] != 0 && GangLvl[playerid] >= 4)
					{
	                	ShowPlayerDialog(playerid, 12500, DIALOG_STYLE_LIST, "{0077FF}Blodhamer Drift :{ffffff} Gang редактор", ">> [1] Назначить место спавна\n>> [2] Изменить цвет банды\n>> [3] Изменить название банды\n>> {ff0000}Удалить банду", ">>", "X");
					}else return SendClientMessage(playerid, 0xFF0000FF, "Вы должны состоять в банде, и у вас должен быть как минимум 4 ранг.");
		        }
		        case 3:
		        {
					if(PGang[playerid] > 0)
					{
	                	ShowPlayerDialog(playerid, 13001, DIALOG_STYLE_MSGBOX, "{0077FF}Blodhamer Drift :{ffffff} Gang Exit", "Вы точно хотите выйти из банды ?", ">>", "X");
					}else return SendClientMessage(playerid, 0xFF0000FF, "Вы должны состоять в банде!");
		        }
		    }
		}
	}
	else if(dialogid == 12005)
	{
 		if(response)
	    {
	    switch(listitem)
		    {
     			case 0:
		        {
		            if(PGang[playerid] != 0 && GangLvl[playerid] == 6)
					{
    	            ShowPlayerDialog(playerid, 13002, DIALOG_STYLE_LIST, "{0077FF}Blodhamer Drift :{ffffff} Gang Skin", ">> [1] Level\n>> [2] Level\n>> [3] Level\n>> [4] Level\n>> [Зам]\n>> [Лидер]", ">>", "X");
	                }else return SendClientMessage(playerid, 0xFF0000FF, "Вы должны состоять в банде, и у вас должен быть ранг лидера.");
		        }
		        case 1:
		        {
		            if(PGang[playerid] != 0 && GangLvl[playerid] == 6)
					{
	                	ShowPlayerDialog(playerid, 13003, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Rank", "Введите id игрока, которому хотите назначит ранг:", ">>", "X");
	                }else return SendClientMessage(playerid, 0xFF0000FF, "Вы должны состоять в банде, и у вас должен быть ранг лидера.");
		        }
		        case 2:
		        {
		            if(PGang[playerid] != 0 && GangLvl[playerid] == 6)
					{
	                	ShowPlayerDialog(playerid, 13004, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Invite", "Введите id игрока, которого хотите пригласить:", ">>", "X");
	                }else return SendClientMessage(playerid, 0xFF0000FF, "Вы должны состоять в банде, и у вас должен быть ранг лидера.");
		        }
		        
		        case 3:
		        {
					if(PGang[playerid] != 0 && GangLvl[playerid] >= 5)
					{
	                	ShowPlayerDialog(playerid, 13005, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff}Gang Kick", "Введите id игрока, которого хотите кикнуть:", ">>", "X");
					}else return SendClientMessage(playerid, 0xFF0000FF, "Вы должны состоять в банде, и у вас должен быть как минимум 5 ранг.");
		        }
		    }
	    }
 	}
 	else if(dialogid == 12500)
	{
 		if(response)
	    {
	    switch(listitem)
		    {
     			case 0:
		        {
		            if(PGang[playerid] != 0 && GangLvl[playerid] == 6)
					{
	                	ShowPlayerDialog(playerid, 13006, DIALOG_STYLE_MSGBOX, "{0077FF}Blodhamer Drift :{ffffff} Gang Spawn", "Вы точно хотите назначить место спавна на этом месте?", ">>", "X");
	                }else return SendClientMessage(playerid, 0xFF0000FF, "Вы должны состоять в банде, и у вас должен быть ранг лидера.");
		        }
		        case 1:
		        {
					if(PGang[playerid] != 0 && GangLvl[playerid] == 6)
					{
	                	ShowPlayerDialog(playerid, 13007, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Color", "Введите 6 символов формата RRGGBB:", ">>", "X");
					}else return SendClientMessage(playerid, 0xFF0000FF, "Вы должны состоять в банде, и у вас должен быть ранг лидера.");
		        }
		        case 2:
		        {
					if(PGang[playerid] != 0 && GetPlayerMoney(playerid) >= 1000000 && GangLvl[playerid] == 6)
					{
	                	ShowPlayerDialog(playerid, 13008, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Name Change", "Введите новое имя банды\nв поле ниже:", ">>", "X");
					}else return SendClientMessage(playerid, 0xFF0000FF, "Для смены имени требуеться: ранг лидера и 1.000.000$");
		        }
		        case 3:
		        {
	        		if(PGang[playerid] != 0 && GangLvl[playerid] == 6)
	        		{
        				ShowPlayerDialog(playerid, 13009, DIALOG_STYLE_MSGBOX, "{0077FF}Blodhamer Drift :{ffffff} Gang Delete", "Вы точно хотите удалить свою банду?", ">>", "X");
					}else return SendClientMessage(playerid, 0xFF0000FF, "Вы должны состоять в банде, и у вас должен быть ранг лидера.");
				}
		    }
	    }
 	}
 	else if(dialogid == 12001)
	{
	    if(response)
	    {
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, 12001, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Create", "Введите название банды:", ">>", "X");
			format(GangName[playerid], 256, inputtext);
			ShowPlayerDialog(playerid, 12050, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Create", "Введите цвет банды:", ">>", "X");
   		}
	}
	else if(dialogid == 12050)
	{
	    if(response)
	    {
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, 12050, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Create", "Введите цвет банды:", ">>", "X");
			if(strlen(inputtext) != 6)
			{
				SendClientMessage(playerid, 0xFF0000, "Значение должно быть из 6 символов формата RRGGBB!");
				return ShowPlayerDialog(playerid, 12050, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Create", "Введите цвет банды:", ">>", "X");
			}
			new f[256],year,month,day,lolo[128]; getdate(year, month, day);
			format(f, 256, "Gangs/%i.ini",GetFreeGang());
			new cfile = ini_createFile(f);
			if(cfile == INI_OK)
			{
				GangLvl[playerid] = 6;
				PGang[playerid] = GetFreeGang();
				format(grname[PGang[playerid]], 256, GangName[playerid]);
				format(GColor[PGang[playerid]], 10, "%sFF", inputtext);
				format(lolo, sizeof(lolo),"%d/%d/%d",day, month, year);
				new hex[MAX_PLAYERS];
				hex[playerid] = HexToInt(GColor[PGang[playerid]]);
				SetPlayerColor(playerid, hex[playerid]);
				Gang[GetFreeGang()] = 1;
				format(string, sizeof(string), "{FFFF00}Банда успешно создана!\r\n{FFFF00}Название банды: %s\r\n{FFFF00}Цвет банды: {%s}%s\r\n{FFFF00}Дата основания: {FFFFFF}%s", grname[PGang[playerid]], inputtext,GColor[PGang[playerid]],lolo);
				ShowPlayerDialog(playerid, 12051, DIALOG_STYLE_MSGBOX, "{0077FF}Blodhamer Drift :{ffffff} Gang Create", string, ">>", "");
			    ini_setString(cfile, "Gang name", grname[PGang[playerid]]);
			    ini_setString(cfile, "Gang color", GColor[PGang[playerid]]);
			    ini_setString(cfile, "founded", lolo);
   			    ini_setFloat(cfile, "SpawnX", 0.0);
			    ini_setFloat(cfile, "SpawnY", 0.0);
			    ini_setFloat(cfile, "SpawnZ", 0.0);
       			ini_setInteger(cfile, "Skin1", 0);
			    ini_setInteger(cfile, "Skin2", 0);
			    ini_setInteger(cfile, "Skin2", 0);
			    ini_setInteger(cfile, "Skin3", 0);
			    ini_setInteger(cfile, "Skin4", 0);
			    ini_setInteger(cfile, "Skin5", 0);
			    ini_setInteger(cfile, "Skin6", 0);
				ini_closeFile(cfile);
			}
	    }
	}
	else if(dialogid == 13004)
	{
	    if(response)
	    {
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, 13004, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Invite", "Введите id игрока, которого хотите пригласить:", ">>", "X");
			if(IsPlayerConnected(strval(inputtext)))
			{
				if(PGang[strval(inputtext)] == 0)
				{
				    format(string, sizeof(string), "Игрок %s пригласил вас в банду '%s'", PlayerName(playerid), grname[PGang[playerid]]);
				    ShowPlayerDialog(strval(inputtext), 12056, DIALOG_STYLE_MSGBOX, "Приглашение в банду", string, "Принять", "Отказать");
				    for(new i; i<MAX_PLAYERS; i++)
				    {
				        if(PGang[i] == PGang[playerid])
				        {
							
							SendClientMessage(i, 0xFF0000FF, string);
				        }
					}
				    tgang[strval(inputtext)] = PGang[playerid];
				}else return SendClientMessage(playerid, 0xFFFFFFFF, "Этот игрок уже в банде!");
			}else return SendClientMessage(playerid, 0xFFFFFFFF, "Этот игрок не в игре!");
	    }
	}
	else if(dialogid == 12056)
	{
	    if(response)
	    {
            PGang[playerid] = tgang[playerid];
            GangLvl[playerid] = 1;
			new hex[MAX_PLAYERS];
			hex[playerid] = HexToInt(GColor[PGang[playerid]]);
			SetPlayerColor(playerid, hex[playerid]);
            format(string, sizeof(string), "Вы вступили в банду '%s'", grname[PGang[playerid]]);
            SendClientMessage(playerid, 0xFFFFFFFF, string);
            format(string, sizeof(string), "%s вступил в банду!", PlayerName(playerid));
            for(new i; i<MAX_PLAYERS; i++)
            {
				if(PGang[i] == PGang[playerid])
				{
				    SendClientMessage(i, 0xFFFF00FF, string);
				}
            }
	    }
	    else
		{
		    tgang[playerid] = 0;
		}
	}
	else if(dialogid == 13005)
	{
	    if(response)
	    {
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, 13005, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Kick", "Введите id игрока, которого хотите кикнуть:", ">>", "X");
			if(IsPlayerConnected(strval(inputtext)))
			{
				if(PGang[strval(inputtext)] == PGang[playerid])
				{
					PGang[strval(inputtext)] = 0;
					GangLvl[strval(inputtext)] = 0;
					format(string, 256, "{FF0000}Вы были кикнуты из банды игроком '{FFFFFF}%s{FF0000}'", PlayerName(playerid));
					SendClientMessage(playerid, 0xFF0000FF, string);
				}else return SendClientMessage(playerid, 0xFFFFFFFF, "Этот игрок не в вашей банде!");
			}else return SendClientMessage(playerid, 0xFFFFFFFF, "Этот игрок не в игре!");
	    }
	}
	else if(dialogid == 13007)
	{
	    if(response)
	    {
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, 13007, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Color", "Введите 6 символов формата RRGGBB:", ">>", "X");
			if(strlen(inputtext) != 6)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Значение должно быть из 6 символов формата RRGGBB!");
				return ShowPlayerDialog(playerid, 13007, DIALOG_STYLE_INPUT, "Смена цвета банды", "Введите 6 символов формата RRGGBB:", ">>", "X");
			}
			format(GColor[PGang[playerid]], 10, "%sFF", inputtext);
			new hex[MAX_PLAYERS];
			hex[playerid] = HexToInt(GColor[PGang[playerid]]);
			SetPlayerColor(playerid,hex[playerid]);
			format(string, sizeof(string), "Теперь цвет вашей банды: {%s}%s", inputtext, GColor[PGang[playerid]]);
			SendClientMessage(playerid, 0xCCFF00FF, string);
			new f[256];
			format(f, 256, "Gangs/%i.ini",PGang[playerid]);
			new file = ini_openFile(f);
			if(file == INI_OK)
			{
				ini_setString(file, "Gang color", GColor[PGang[playerid]]);
				ini_closeFile(file);
			}
	    }
	}
	else if(dialogid == 13001)
	{
	    if(response)
	    {
	        format(string,sizeof(string), "{FFFF00}'{FFFFFF}%s{FFFF00}' ушёл из банды!", PlayerName(playerid));
	        for(new i; i<MAX_PLAYERS; i++)
	        {
				if(PGang[i] == PGang[playerid] && i != playerid)
				{
				 	SendClientMessage(i, 0xFFFF00, string);
				}
			}
			PGang[playerid] = 0;
			GangLvl[playerid] = 0;
	    }
	}
	else if(dialogid == 13006)
	{
	    if(response)
	    {
	        new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			GSpawnX[PGang[playerid]] = x;
			GSpawnY[PGang[playerid]] = y;
			GSpawnZ[PGang[playerid]] = z;
            new f[256];
			format(f, 256, "Gangs/%i.ini", PGang[playerid]);
			new file = ini_openFile(f);
			if(file == INI_OK)
			{
			    ini_setFloat(file, "SpawnX", x);
			    ini_setFloat(file, "SpawnY", y);
			    ini_setFloat(file, "SpawnZ", z);
			    ini_closeFile(file);
			}else return SendClientMessage(playerid, 0xFF0000FF, "Спавн банды успешно установлен!");
	    }
	}
	else if(dialogid == 13002)
	{
	    if(response)
	    {
			switch(listitem)
			{
	            case 0: gangskin[playerid] = 1;
	            case 1: gangskin[playerid] = 2;
	            case 2: gangskin[playerid] = 3;
		        case 3: gangskin[playerid] = 4;
	            case 4: gangskin[playerid] = 5;
	            case 5: gangskin[playerid] = 6;
			}
			ShowPlayerDialog(playerid, 12060, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Skin", "Введите в окошко ID скина, который хотите назначить:", "Принять", "Отмена");
	    }
	}
	else if(dialogid == 12060)
	{
	    if(response)
	    {
			if(!strlen(inputtext) && strval(inputtext) > 0) return ShowPlayerDialog(playerid, 12060, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Skin", "Введите в окошко ID скина, который хотите назначить:", "Принять", "Отмена");
            new f[256];
			format(f, 256, "Gangs/%i.ini",PGang[playerid]);
			new file = ini_openFile(f);
			if(file == INI_OK)
			{
				format(string, 256, "Skin%i", gangskin[playerid]);
			    ini_setInteger(file, string, strval(inputtext));
			    ini_closeFile(file);
				format(string, sizeof(string), "Скин успешно установлен! ID скина: %i", strval(inputtext));
				SendClientMessage(playerid, 0xFFFF00FF, string);
				GSkin[PGang[playerid]][gangskin[playerid]-1] = strval(inputtext);
				for(new i; i<MAX_PLAYERS; i++)
				{
				    if(PGang[i] == PGang[playerid] && GangLvl[i] == gangskin[playerid])
				    {
				        SetPlayerSkin(i, strval(inputtext));
				    }
				}
				gangskin[playerid] = 0;
			}
	    }
	}
	else if(dialogid == 13003)
	{
	    if(response)
	    {
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, 13003, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Rang", "Введите id игрока, которому хотите назначит ранг:", ">>", "X");
			if(PGang[strval(inputtext)] != PGang[playerid])
			{
			    SendClientMessage(playerid, 0xFFFF00FF, "Игрок не в вашей банде!");
			    return ShowPlayerDialog(playerid, 13003, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Rang", "Введите id игрока, которому хотите назначит ранг:", ">>", "X");
			}
			id[playerid] = strval(inputtext);
			ShowPlayerDialog(playerid, 12065, DIALOG_STYLE_LIST, "{0077FF}Blodhamer Drift :{ffffff} Gang Rang", ">> [1] Level\n>> [2] Level\n>> [3] Level\n>> [4] Level\n>> [Зам]\n>> [Лидер]", ">>", "X");
	    }
	}
	else if(dialogid == 12065)
	{
	    if(response)
	    {
	        switch(listitem)
			{
	            case 0: GangLvl[id[playerid]] = 1;
	            case 1: GangLvl[id[playerid]] = 2;
	            case 2: GangLvl[id[playerid]] = 3;
		        case 3: GangLvl[id[playerid]] = 4;
	            case 4: GangLvl[id[playerid]] = 5;
	            case 5: GangLvl[id[playerid]] = 6;
			}
			format(string, sizeof(string), "Вы выдали игроку %s ранг %i", PlayerName(id[playerid]), GangLvl[id[playerid]]);
			SendClientMessage(playerid, 0xFFFF00FF, string);
			format(string, sizeof(string), "Лидер %s выдал Вам ранг %i", PlayerName(playerid), GangLvl[id[playerid]]);
			SendClientMessage(id[playerid], 0xFFFF00FF, string);
			if(GSkin[PGang[playerid]][GangLvl[id[playerid]]] > 0) SetPlayerSkin(id[playerid], GSkin[PGang[playerid]][GangLvl[id[playerid]]-1]);
			id[playerid] = -1;
	    }
	}
	else if(dialogid == 13008)
	{
	    if(response)
	    {
			if(!strlen(inputtext)) return ShowPlayerDialog(playerid, 13008, DIALOG_STYLE_INPUT, "{0077FF}Blodhamer Drift :{ffffff} Gang Name Change", "Введите новое имя банды\nв поле ниже:", ">>", "X");
			format(grname[PGang[playerid]], 256, "%s", inputtext);
			format(string, sizeof(string), "\n{FFFF00}Вы успешно изменили имя банды!\nНовое имя банды: {FF0000}%s\n",inputtext);
			ShowPlayerDialog(playerid, 13008, DIALOG_STYLE_MSGBOX, "{0077FF}Blodhamer Drift :{ffffff} Gang Name Change", string, ">>", "");
			new f[256];
			format(f, 256, "Gangs/%i.ini",PGang[playerid]);
			new file = ini_openFile(f);
			if(file == INI_OK)
			{
				ini_setString(file, "Gang name", grname[PGang[playerid]]);
				ini_closeFile(file);
			}
	    }
  	}
	else if(dialogid == 13009)
 	{
		if(response)
	    {
     		new f[256];
			format(f, 256, "Gangs/%i.ini",PGang[playerid]);
			fremove(f);
			PGang[playerid] = 0;
    		GangLvl[playerid] = 0;
        	SendClientMessage(playerid, 0xFFFF00FF, "Ваша банда успешно удалена!");
		}
	}
	return true;
}

stock GetFreeGang()
{
	for(new i=1; i<MAX_GANGS; i++)
	{
		if(Gang[i] == 0) return i;
	}
	return false;
}

forward LoadAccount(playerid);
public LoadAccount(playerid)
{
    new f[256], hex[MAX_PLAYERS];
    format(f, 256, "Users/%s.ini", PlayerName(playerid));
	new file = ini_openFile(f);
	if(file == INI_OK)
	{
	    ini_getInteger(file, "Gang", PGang[playerid]);
	    ini_getInteger(file, "GangLvl", GangLvl[playerid]);
	    if(PGang[playerid] > 0)
	    {
			hex[playerid] = HexToInt(GColor[PGang[playerid]]);
			SetPlayerColor(playerid, hex[playerid]);
		}
		ini_closeFile(file);
		return true;
	}
	else
	{
	    ini_closeFile(file);
	    file = ini_createFile(f);
	    ini_setInteger(file, "Gang", 0);
	    ini_setInteger(file, "GangLvl", 0);
		ini_closeFile(file);
		return true;
	}
}

forward SaveAccount(playerid);
public SaveAccount(playerid)
{
    new f[256];
    format(f, 256, "Users/%s.ini", PlayerName(playerid));
	new file = ini_openFile(f);
	if(file == INI_OK)
	{
	    ini_setInteger(file, "Gang", PGang[playerid]);
	    ini_setInteger(file, "GangLvl", GangLvl[playerid]);
		ini_closeFile(file);
	}
	return true;
}

forward GangLoad();
public GangLoad()
{
    new file, f[256];
	for(new i; i<MAX_GANGS; i++)
	{
	    format(f, 256, "Gangs/%i.ini",i);
		file = ini_openFile(f);
		if(file == INI_OK)
		{
		    ini_getString(file, "Gang name", name[i]);
		    format(grname[i], 256, name[i]);
		    ini_getString(file, "Gang color", col[i]);
		    format(GColor[i], 10, col[i]);
		    ini_getFloat(file, "SpawnX", GSpawnX[i]);
		    ini_getFloat(file, "SpawnY", GSpawnY[i]);
		    ini_getFloat(file, "SpawnZ", GSpawnZ[i]);
		    ini_getInteger(file, "Skin1", GSkin[i][0]);
		    ini_getInteger(file, "Skin2", GSkin[i][1]);
		    ini_getInteger(file, "Skin3", GSkin[i][2]);
		    ini_getInteger(file, "Skin4", GSkin[i][3]);
		    ini_getInteger(file, "Skin5", GSkin[i][4]);
		    ini_getInteger(file, "Skin6", GSkin[i][5]);
		    Gang[i] = 1;
			ini_closeFile(file);
		}
	}
	return true;
}

forward Spawn(playerid);
public Spawn(playerid)
{
    if(GSkin[PGang[playerid]][GangLvl[playerid]-1] > 0)
	{
 		SetPlayerSkin(playerid, GSkin[PGang[playerid]][GangLvl[playerid]-1]);
	}
	if(GSpawnX[PGang[playerid]] != 0.0 && GSpawnY[PGang[playerid]] != 0.0 && GSpawnZ[PGang[playerid]] != 0.0)
	{
		SetPlayerPos(playerid, GSpawnX[PGang[playerid]], GSpawnY[PGang[playerid]], GSpawnZ[PGang[playerid]]);
	}
	new hex[MAX_PLAYERS];
	hex[playerid] = HexToInt(GColor[PGang[playerid]]);
	SetPlayerColor(playerid, hex[playerid]);
}

stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock PlayerName(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid,pname,sizeof(pname));
	return pname;
}

stock HexToInt(string[]) {
  if (string[0]==0) return 0;
  new i;
  new cur=1;
  new res=0;
  for (i=strlen(string);i>0;i--) {
    if (string[i-1]<58) res=res+cur*(string[i-1]-48); else res=res+cur*(string[i-1]-65+10);
    cur=cur*16;
  }
  return res;
}

stock IntToHex(number)
{
  new m=1;
  new depth=0;
  while (number>=m) {
   m = m*16;
   depth++;
  }
  depth--;
  new str[125];
  for (new i = depth; i >= 0; i--)
  {
   str[i] = ( number & 0x0F) + 0x30; // + (tmp > 9 ? 0x07 : 0x00)
   str[i] += (str[i] > '9') ? 0x07 : 0x00;
   number >>= 4;
  }
  str[8] = '\0';
  return str;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
    if(listid == skinlist)
    {
	    if(response)
	    {
	    	SetPlayerSkin(playerid, modelid);
	    }
	  }
	return 0;
}

