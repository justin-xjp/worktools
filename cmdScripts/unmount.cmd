cd C:\Users\用户名\Desktop\selina
echo select vdisk file=e:\keep\mp.vhd>vhdsel
echo detach vdisk>>vhdsel
echo select vdisk file=e:\keep\rocp.vhd>>vhdsel
echo detach vdisk>>vhdsel
echo list disk>>vhdsel
echo exit>>vhdsel
diskpart /s %cd%/vhdsel
del /f /q vhdsel
exit