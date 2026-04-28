-- 1. Tabla Ciudades
CREATE TABLE Ciudades (
    id CHAR(5) PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    pais VARCHAR2(100) NOT NULL
);

-- 2. Tabla Usuarios
CREATE TABLE Usuarios (
    id CHAR(10) PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    apellido VARCHAR2(100) NOT NULL,
    correo VARCHAR2(150) NOT NULL,
    contraseña VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(20) NOT NULL,
    tipo_usuario VARCHAR2(20) CHECK (tipo_usuario IN ('cliente', 'admin'))
);

-- 3. Tabla Hoteles
CREATE TABLE Hoteles (
    id CHAR(10) PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    direccion VARCHAR2(200) NOT NULL,
    telefono INTEGER NOT NULL,
    descripcion VARCHAR2(500),
    ciudad CHAR(5) NOT NULL,
    user_admin CHAR(10) NOT NULL,
    CONSTRAINT fk_hotel_ciudad FOREIGN KEY (ciudad) REFERENCES Ciudades(id),
    CONSTRAINT fk_hotel_admin FOREIGN KEY (user_admin) REFERENCES Usuarios(id)
);

-- 4. Tabla TiposHabitaciones
CREATE TABLE TiposHabitaciones (
    id CHAR(5) PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    costo_tbaja FLOAT NOT NULL,
    costo_talta FLOAT NOT NULL,
    dimensiones INTEGER NOT NULL,
    tipos_camas VARCHAR2(50) CHECK (tipos_camas IN ('King', 'Queen', 'Single', 'Double')),
    tipos_vistas VARCHAR2(50) NOT NULL,
    aire_acondicionado NUMBER(1) CHECK (aire_acondicionado IN (0,1)),
    calefaccion NUMBER(1) CHECK (calefaccion IN (0,1)),
    television NUMBER(1) CHECK (television IN (0,1)),
    wifi NUMBER(1) CHECK (wifi IN (0,1)),
    minibar NUMBER(1) CHECK (minibar IN (0,1)),
    bano_privado NUMBER(1) CHECK (bano_privado IN (0,1)),
    hotel CHAR(10) NOT NULL,
    CONSTRAINT fk_tipo_hotel FOREIGN KEY (hotel) REFERENCES Hoteles(id)
);

-- 5. Tabla Reservas
CREATE TABLE Reservas (
    id CHAR(10) PRIMARY KEY,
    fecha_llegada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    numero_noches INTEGER NOT NULL,
    precio_total FLOAT NOT NULL,
    temporada VARCHAR2(10) CHECK (temporada IN ('baja', 'alta')),
    menores_3_anios INTEGER,
    personas_adultas INTEGER NOT NULL,
    id_usuario CHAR(10) NOT NULL,
    CONSTRAINT fk_reserva_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id)
);

-- 6. Tabla Habitaciones
CREATE TABLE Habitaciones (
    numero INTEGER PRIMARY KEY,
    tipo_habitacion CHAR(5) NOT NULL,
    hotel CHAR(10) NOT NULL,
    id_reserva CHAR(10),
    CONSTRAINT fk_hab_tipo FOREIGN KEY (tipo_habitacion) REFERENCES TiposHabitaciones(id),
    CONSTRAINT fk_hab_hotel FOREIGN KEY (hotel) REFERENCES Hoteles(id),
    CONSTRAINT fk_hab_reserva FOREIGN KEY (id_reserva) REFERENCES Reservas(id)
);

-- 7. Tabla Servicios
CREATE TABLE Servicios (
    codigo CHAR(10) PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(500),
    tipo_servicio VARCHAR2(20) CHECK (tipo_servicio IN ('fijo', 'por consumo')),
    precio FLOAT NOT NULL,
    id_reserva CHAR(10) NOT NULL,
    numero_habitacion INTEGER NOT NULL,
    costo_total FLOAT NOT NULL,
    dias_uso INTEGER NOT NULL,
    CONSTRAINT fk_serv_reserva FOREIGN KEY (id_reserva) REFERENCES Reservas(id),
    CONSTRAINT fk_serv_hab FOREIGN KEY (numero_habitacion) REFERENCES Habitaciones(numero)
);