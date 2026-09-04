import 'package:flutter/material.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/domain/models/Role.dart';
import 'package:myfirstlove/src/routing/app_router.dart';

class RolesItem extends StatelessWidget {
  final Role role;

  const RolesItem(this.role, {super.key});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color roleColor;
    String subtitle;
    String route = role.route;

    final roleId = role.id.toUpperCase();
    if (roleId.contains('MEDIC') || roleId.contains('DOCTOR')) {
      icon = Icons.medical_services_outlined;
      roleColor = AppColors.primary;
      subtitle = 'Gestionar citas, atender pacientes y registrar diagnósticos';
      route = AppRoutes.homeDoctor;
    } else if (roleId.contains('ADMIN')) {
      icon = Icons.admin_panel_settings_outlined;
      roleColor = AppColors.primary_admin;
      subtitle = 'Métricas del sistema, gestión de médicos y especialidades';
      route = AppRoutes.homeAdmin;
    } else {
      icon = Icons.person_outline;
      roleColor = AppColors.secondary;
      subtitle = 'Reservar citas, ver consultas médicas e historial';
      route = AppRoutes.homeClient;
    }

    return InkWell(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: roleColor.withOpacity(0.3), width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: roleColor.withOpacity(0.12),
                child: Icon(icon, color: roleColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.name,
                      style: TextStyle(
                        fontSize: 17,
                        color: roleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: roleColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}