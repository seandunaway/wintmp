#include <windows.h>

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
	if (uMsg == WM_DESTROY) PostQuitMessage(0);
	return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

int APIENTRY WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
	WNDCLASS wc = {0};
	wc.lpfnWndProc = WindowProc;
	wc.hInstance = hInstance;
	wc.lpszClassName = L"❤️";
    	RegisterClass(&wc);

	HWND hwnd = CreateWindowEx(
		WS_EX_TOPMOST,
		wc.lpszClassName,
		L"❤️",
		(WS_OVERLAPPEDWINDOW & ~WS_MAXIMIZEBOX & ~WS_MINIMIZEBOX) | WS_VISIBLE,
		0, 0,
		1, 1,
		NULL,
		NULL,
		hInstance,
		NULL
    	);
	ShowWindow(hwnd, SW_SHOWNORMAL);

	MSG msg;
	while (GetMessage(&msg, NULL, 0, 0)) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return 0;
}
