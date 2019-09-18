#pragma semicolon 1

#include <sourcemod>
#include <sdkhooks>

#define PLUGIN_VERSION "1.0"

new bool:bLateLoad = false;

public Plugin:myinfo = {
	name        = "Anti-HeadShake for Bunnyhop",
	author      = "ici",
	description = "Disables the annoying screen shaking effect when somebody shoots you in the head.",
	version 	= PLUGIN_VERSION
};

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	bLateLoad = late;
	return APLRes_Success;
}

public OnPluginStart()
{
	if (bLateLoad) {
		for (new i = 1; i <= MaxClients; i++) {
			if (IsClientConnected(i) && IsClientInGame(i)) {
				OnClientPutInServer(i);
			}
		}
	}
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_OnTakeDamage, Hook_OnTakeDamage);
}

public Action:Hook_OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	static Float:vec[3] = {0.0, 0.0, 0.0};
	if (attacker > 0 && attacker <= MaxClients && victim > 0 && victim <= MaxClients) {
		SetEntPropVector(victim, Prop_Send, "m_vecPunchAngle", vec);
		SetEntPropVector(victim, Prop_Send, "m_vecPunchAngleVel", vec);
	}
	return Plugin_Continue;
}
