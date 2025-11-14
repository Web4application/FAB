; TrayIconFX.au3
#include <TrayConstants.au3>
#include <GDIPlus.au3>

Func TrayIcon_Update($iPercent)
    _GDIPlus_Startup()
    Local $hBitmap = _GDIPlus_BitmapCreateFromScan0(16,16,0)
    Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    Local $hBrush = _GDIPlus_BrushCreateSolid(0xFF00FF00)
    _GDIPlus_GraphicsFillRectangle($hGraphics, 0, 16-$iPercent/6, 16, $iPercent/6, $hBrush)
    _GDIPlus_BitmapSetToIcon($hBitmap, TraySetIcon(@ScriptFullPath))
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_GraphicsDispose($hGraphics)
    _GDIPlus_BitmapDispose($hBitmap)
    _GDIPlus_Shutdown()
EndFunc
