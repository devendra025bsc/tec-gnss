# -*- mode: python ; coding: utf-8 -*-
# PyInstaller spec for GPS TEC Advanced
# numpy must be <2.0  (pinned in requirements.txt)
from PyInstaller.utils.hooks import collect_data_files, collect_submodules, collect_dynamic_libs

# ── numpy: explicit _core submodules (the ones PyInstaller misses) ───────────
numpy_hidden = collect_submodules('numpy')

# ── pandas ───────────────────────────────────────────────────────────────────
pandas_hidden = collect_submodules('pandas')

# ── matplotlib ───────────────────────────────────────────────────────────────
mpl_hidden = collect_submodules('matplotlib')
mpl_data   = collect_data_files('matplotlib', include_py_files=True)

# ── hatanaka ─────────────────────────────────────────────────────────────────
hatanaka_hidden = collect_submodules('hatanaka')
hatanaka_data   = collect_data_files('hatanaka')

# ── numpy binary extensions (the C-extension DLLs that get missed) ───────────
numpy_bins = collect_dynamic_libs('numpy')

hiddenimports = list(dict.fromkeys([
    # numpy _core internals — the ones that trigger the error
    'numpy._core',
    'numpy._core._multiarray_umath',
    'numpy._core._multiarray_tests',
    'numpy._core._exceptions',
    'numpy._core._dtype',
    'numpy._core._dtype_ctypes',
    'numpy._core._internal',
    'numpy._core.arrayprint',
    'numpy._core.defchararray',
    'numpy._core.einsumfunc',
    'numpy._core.fromnumeric',
    'numpy._core.function_base',
    'numpy._core.getlimits',
    'numpy._core.memmap',
    'numpy._core.multiarray',
    'numpy._core.numeric',
    'numpy._core.numerictypes',
    'numpy._core.overrides',
    'numpy._core.records',
    'numpy._core.shape_base',
    'numpy._core.umath',
    # numpy top-level
    'numpy.lib.stride_tricks',
    'numpy.random',
    'numpy.fft',
    'numpy.linalg',
    # tkinter
    'tkinter', 'tkinter.ttk', 'tkinter.messagebox', 'tkinter.filedialog',
    # stdlib
    'bisect', 'logging', 'threading', 'json', 'gzip',
    'concurrent.futures', 'urllib.request', 'urllib.error',
    # collected
    *numpy_hidden,
    *pandas_hidden,
    *mpl_hidden,
    *hatanaka_hidden,
]))

datas  = mpl_data + hatanaka_data
binaries = numpy_bins

a = Analysis(
    ['src/launch_gui.py'],
    pathex=['src'],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'PyQt5','PyQt6','PySide2','PySide6','wx',
        'IPython','jupyter','notebook','pytest','sphinx',
        'matplotlib.backends.backend_gtk3',
        'matplotlib.backends.backend_gtk3agg',
        'matplotlib.backends.backend_gtk3cairo',
        'matplotlib.backends.backend_gtk4',
        'matplotlib.backends.backend_gtk4agg',
        'matplotlib.backends.backend_gtk4cairo',
        'matplotlib.backends.backend_macosx',
        'matplotlib.backends.backend_qt',
        'matplotlib.backends.backend_qt5',
        'matplotlib.backends.backend_qt5agg',
        'matplotlib.backends.backend_qt5cairo',
        'matplotlib.backends.backend_qtagg',
        'matplotlib.backends.backend_qtcairo',
        'matplotlib.backends.backend_wx',
        'matplotlib.backends.backend_wxagg',
        'matplotlib.backends.backend_wxcairo',
        'matplotlib.backends.backend_cairo',
        'matplotlib.backends.backend_webagg',
        'matplotlib.backends.backend_nbagg',
        'matplotlib.sphinxext',
        'matplotlib.testing',
    ],
    noarchive=False,
    optimize=0,
)

pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='GPS_TEC_Advanced',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    console=False,
)

COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=False,
    name='GPS_TEC_Advanced',
)
