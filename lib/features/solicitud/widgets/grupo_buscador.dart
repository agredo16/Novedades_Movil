import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../data/models/grupo_model.dart';

class GrupoBuscador extends StatefulWidget {
  final List<GrupoModel> grupos;
  final String label;
  final String hint;
  final int? grupoSeleccionadoId;
  final Function(GrupoModel) onSelect;

  const GrupoBuscador({
    super.key,
    required this.grupos,
    required this.label,
    required this.hint,
    required this.grupoSeleccionadoId,
    required this.onSelect,
  });

  @override
  State<GrupoBuscador> createState() => _GrupoBuscadorState();
}

class _GrupoBuscadorState extends State<GrupoBuscador> {
  final _controller = TextEditingController();
  List<GrupoModel> _resultados = [];
  GrupoModel? _seleccionado;
  bool _mostrarResultados = false;

  @override
  void initState() {
    super.initState();
    // Si ya hay un grupo seleccionado cargarlo
    if (widget.grupoSeleccionadoId != null) {
      _seleccionado = widget.grupos.firstWhere(
        (g) => g.id == widget.grupoSeleccionadoId,
        orElse: () => widget.grupos.first,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _buscar(String query) {
    if (query.isEmpty) {
      setState(() {
        _resultados = [];
        _mostrarResultados = false;
      });
      return;
    }

    final q = query.toLowerCase();
    final resultados = widget.grupos.where((g) =>
      g.nombreCurso.toLowerCase().contains(q) ||
      g.codCurso.toLowerCase().contains(q)    ||
      g.codigoGrupo.toLowerCase().contains(q) ||
      g.docente.toLowerCase().contains(q),
    ).toList();

    setState(() {
      _resultados        = resultados;
      _mostrarResultados = true;
    });
  }

  void _seleccionar(GrupoModel grupo) {
    setState(() {
      _seleccionado      = grupo;
      _mostrarResultados = false;
      _controller.clear();
    });
    widget.onSelect(grupo);
  }

  void _limpiar() {
    setState(() {
      _seleccionado      = null;
      _mostrarResultados = false;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Label ──────────────────────────────────
        Text(widget.label,
            style: AppTypography.sm.copyWith(
                fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.s2),

        // ── Grupo seleccionado ──────────────────────
        if (_seleccionado != null) ...[
          _buildGrupoCard(_seleccionado!, selected: true),
          const SizedBox(height: AppSpacing.s2),
          GestureDetector(
            onTap: _limpiar,
            child: Row(
              children: [
                const Icon(Icons.swap_horiz_rounded,
                    color: AppColors.primary, size: 16),
                const SizedBox(width: 4),
                Text('Cambiar selección',
                    style: AppTypography.xs.copyWith(
                        color: AppColors.primary)),
              ],
            ),
          ),
        ] else ...[

          // ── Campo de búsqueda ───────────────────
          TextField(
            controller: _controller,
            onChanged: _buscar,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTypography.sm.copyWith(
                  color: AppColors.gray400),
              prefixIcon: const Icon(Icons.search,
                  color: AppColors.gray400),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.gray400, size: 18),
                      onPressed: () {
                        _controller.clear();
                        _buscar('');
                      },
                    )
                  : null,
            ),
          ),

          // ── Resultados ─────────────────────────
          if (_mostrarResultados) ...[
            const SizedBox(height: AppSpacing.s2),
            if (_resultados.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.s3),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                      color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_off,
                        color: AppColors.warning, size: 16),
                    const SizedBox(width: AppSpacing.s2),
                    Text('Sin coincidencias',
                        style: AppTypography.sm.copyWith(
                            color: AppColors.warning)),
                  ],
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.gray200),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gray200.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: _resultados.asMap().entries.map((entry) {
                    final isLast =
                        entry.key == _resultados.length - 1;
                    return Column(
                      children: [
                        _buildGrupoCard(
                          entry.value,
                          onTap: () => _seleccionar(entry.value),
                        ),
                        if (!isLast)
                          Divider(
                              height: 1, color: AppColors.gray100),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ],
      ],
    );
  }

  Widget _buildGrupoCard(GrupoModel grupo,
      {bool selected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s3),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.06)
              : AppColors.white,
          borderRadius: selected
              ? BorderRadius.circular(AppSpacing.radiusMd)
              : null,
          border: selected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.gray100,
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(Icons.class_outlined,
                  color: selected
                      ? AppColors.white
                      : AppColors.gray500,
                  size: 20),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(grupo.nombreCurso,
                      style: AppTypography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? AppColors.primary
                            : AppColors.gray900,
                      )),
                  const SizedBox(height: 2),
                  Text(
                    '${grupo.codigoGrupo} · ${grupo.jornadaLabel} · ${grupo.diaSemana}',
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray500),
                  ),
                  Text(
                    '${_hora(grupo.horaInicio)} - ${_hora(grupo.horaFin)} · ${grupo.docente}',
                    style: AppTypography.xs.copyWith(
                        color: AppColors.gray500),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (selected)
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.primary, size: 18),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: grupo.tieneCupos
                        ? AppColors.successLight
                        : AppColors.errorLight,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    grupo.tieneCupos
                        ? '${grupo.cuposDisponibles} cupos'
                        : 'Sin cupos',
                    style: AppTypography.xs.copyWith(
                      color: grupo.tieneCupos
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _hora(String hora) {
    try {
      final p = hora.split(':');
      int h   = int.parse(p[0]);
      final m = p[1];
      final ampm = h >= 12 ? 'PM' : 'AM';
      if (h > 12) h -= 12;
      if (h == 0) h = 12;
      return '$h:$m $ampm';
    } catch (_) {
      return hora;
    }
  }
}