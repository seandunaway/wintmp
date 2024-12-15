#include <Windows.h>
#include <dwmapi.h>

#define window_caption_search_text "Sierra Chart"

void set_darkmode_recursive (HWND hwnd)
{
	BOOL darkmode = true;
	COLORREF black = 0x000000;

	DwmSetWindowAttribute(hwnd, 19, &darkmode, sizeof(darkmode));
	DwmSetWindowAttribute(hwnd, 20, &darkmode, sizeof(darkmode));
	DwmSetWindowAttribute(hwnd, DWMWA_USE_IMMERSIVE_DARK_MODE, &darkmode, sizeof(darkmode));
	DwmSetWindowAttribute(hwnd, DWMWA_BORDER_COLOR, &black, sizeof(black));

	HWND child = GetWindow(hwnd, GW_CHILD);

	while (child)
	{
		set_darkmode_recursive(child);

		child = GetWindow(child, GW_HWNDNEXT);
	}
}

BOOL CALLBACK enum_windows_proc (HWND hwnd, LPARAM lParam)
{
	char window_caption[256];
	GetWindowTextA(hwnd, window_caption, sizeof(window_caption));

	if (!strstr(window_caption, window_caption_search_text))
		return TRUE;

	set_darkmode_recursive(hwnd);

	DWORD process_id;
	DWORD thread_id = GetWindowThreadProcessId(hwnd, &process_id);
	HWND next = GetTopWindow(NULL);

	while (next)
	{
		if (GetWindowThreadProcessId(next, NULL) == thread_id)
			set_darkmode_recursive(next);

		next = GetNextWindow(next, GW_HWNDNEXT);
	}

	return TRUE;
}

int main (void)
{
	EnumWindows(enum_windows_proc, 0);
}
