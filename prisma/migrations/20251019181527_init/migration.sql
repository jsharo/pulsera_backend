-- CreateEnum
CREATE TYPE "EstadoDispositivo" AS ENUM ('activo', 'inactivo', 'falla');

-- CreateEnum
CREATE TYPE "TipoAlerta" AS ENUM ('manual', 'automatica');

-- CreateEnum
CREATE TYPE "EstadoAlerta" AS ENUM ('pendiente', 'en_camino', 'atendida', 'cancelada');

-- CreateEnum
CREATE TYPE "EstadoAlertaMedicacion" AS ENUM ('pendiente', 'enviada', 'confirmada', 'omitida');

-- CreateEnum
CREATE TYPE "EstadoNotificacion" AS ENUM ('enviada', 'recibida', 'leida', 'fallo');

-- CreateEnum
CREATE TYPE "TipoNotificacion" AS ENUM ('emergencia', 'medicacion');

-- CreateTable
CREATE TABLE "usuarios" (
    "id_usuario" SERIAL NOT NULL,
    "nombre" VARCHAR(100) NOT NULL,
    "telefono" VARCHAR(15),
    "direccion" TEXT,
    "fecha_nacimiento" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id_usuario")
);

-- CreateTable
CREATE TABLE "dispositivos" (
    "id_dispositivo" SERIAL NOT NULL,
    "id_usuario" INTEGER NOT NULL,
    "mac_address" VARCHAR(17) NOT NULL,
    "nombre_pulsera" VARCHAR(50) NOT NULL DEFAULT 'Pulsera Principal',
    "bateria" INTEGER NOT NULL DEFAULT 100,
    "estado" "EstadoDispositivo" NOT NULL DEFAULT 'activo',
    "ultima_conexion" TIMESTAMP(3),

    CONSTRAINT "dispositivos_pkey" PRIMARY KEY ("id_dispositivo")
);

-- CreateTable
CREATE TABLE "contactos" (
    "id_contacto" SERIAL NOT NULL,
    "id_usuario" INTEGER NOT NULL,
    "nombre" VARCHAR(100) NOT NULL,
    "telefono" VARCHAR(15) NOT NULL,
    "email" VARCHAR(100),
    "prioridad" INTEGER NOT NULL DEFAULT 1,
    "token_notificacion" TEXT,

    CONSTRAINT "contactos_pkey" PRIMARY KEY ("id_contacto")
);

-- CreateTable
CREATE TABLE "medicamentos" (
    "id_medicamento" SERIAL NOT NULL,
    "nombre" VARCHAR(100) NOT NULL,
    "descripcion" TEXT,
    "instrucciones" TEXT,

    CONSTRAINT "medicamentos_pkey" PRIMARY KEY ("id_medicamento")
);

-- CreateTable
CREATE TABLE "horarios_medicacion" (
    "id_horario" SERIAL NOT NULL,
    "id_usuario" INTEGER NOT NULL,
    "id_medicamento" INTEGER NOT NULL,
    "dosis" VARCHAR(50) NOT NULL,
    "hora" TIMESTAMP(3) NOT NULL,
    "dias_semana" VARCHAR(13) NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "horarios_medicacion_pkey" PRIMARY KEY ("id_horario")
);

-- CreateTable
CREATE TABLE "alertas" (
    "id_alerta" SERIAL NOT NULL,
    "id_dispositivo" INTEGER NOT NULL,
    "tipo_alerta" "TipoAlerta" NOT NULL,
    "fecha_hora" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ubicacion" TEXT,
    "estado" "EstadoAlerta" NOT NULL DEFAULT 'pendiente',

    CONSTRAINT "alertas_pkey" PRIMARY KEY ("id_alerta")
);

-- CreateTable
CREATE TABLE "alertas_medicacion" (
    "id_alerta_med" SERIAL NOT NULL,
    "id_horario" INTEGER NOT NULL,
    "fecha_hora_programada" TIMESTAMP(3) NOT NULL,
    "fecha_hora_envio" TIMESTAMP(3),
    "estado" "EstadoAlertaMedicacion" NOT NULL DEFAULT 'pendiente',

    CONSTRAINT "alertas_medicacion_pkey" PRIMARY KEY ("id_alerta_med")
);

-- CreateTable
CREATE TABLE "notificaciones" (
    "id_notificacion" SERIAL NOT NULL,
    "id_alerta" INTEGER,
    "id_alerta_med" INTEGER,
    "id_contacto" INTEGER NOT NULL,
    "fecha_envio" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "estado" "EstadoNotificacion" NOT NULL DEFAULT 'enviada',
    "tipo_notificacion" "TipoNotificacion" NOT NULL,

    CONSTRAINT "notificaciones_pkey" PRIMARY KEY ("id_notificacion")
);

-- CreateIndex
CREATE UNIQUE INDEX "dispositivos_mac_address_key" ON "dispositivos"("mac_address");

-- AddForeignKey
ALTER TABLE "dispositivos" ADD CONSTRAINT "dispositivos_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "usuarios"("id_usuario") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "contactos" ADD CONSTRAINT "contactos_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "usuarios"("id_usuario") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "horarios_medicacion" ADD CONSTRAINT "horarios_medicacion_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "usuarios"("id_usuario") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "horarios_medicacion" ADD CONSTRAINT "horarios_medicacion_id_medicamento_fkey" FOREIGN KEY ("id_medicamento") REFERENCES "medicamentos"("id_medicamento") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alertas" ADD CONSTRAINT "alertas_id_dispositivo_fkey" FOREIGN KEY ("id_dispositivo") REFERENCES "dispositivos"("id_dispositivo") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "alertas_medicacion" ADD CONSTRAINT "alertas_medicacion_id_horario_fkey" FOREIGN KEY ("id_horario") REFERENCES "horarios_medicacion"("id_horario") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notificaciones" ADD CONSTRAINT "notificaciones_id_contacto_fkey" FOREIGN KEY ("id_contacto") REFERENCES "contactos"("id_contacto") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notificaciones" ADD CONSTRAINT "notificaciones_id_alerta_fkey" FOREIGN KEY ("id_alerta") REFERENCES "alertas"("id_alerta") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notificaciones" ADD CONSTRAINT "notificaciones_id_alerta_med_fkey" FOREIGN KEY ("id_alerta_med") REFERENCES "alertas_medicacion"("id_alerta_med") ON DELETE CASCADE ON UPDATE CASCADE;
