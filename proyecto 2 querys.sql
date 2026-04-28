--RFC 1
SELECT h.numero AS "Habitación", 
       th.nombre AS "Tipo", 
       th.costo_talta AS "Costo T. Alta", 
       th.costo_tbaja AS "Costo T. Baja"
FROM Habitaciones h
JOIN TiposHabitaciones th ON h.tipo_habitacion = th.id
WHERE h.hotel = :P10_ID_HOTEL 
AND h.numero NOT IN (
    SELECT hab.numero
    FROM Habitaciones hab
    JOIN Reservas r ON hab.id_reserva = r.id
    WHERE r.fecha_llegada < TO_DATE(:P10_FECHA_FIN, 'DD/MM/YYYY') 
      AND r.fecha_salida > TO_DATE(:P10_FECHA_INICIO, 'DD/MM/YYYY')
);

-- RFC 2
SELECT TO_CHAR(r.fecha_llegada, 'DD/MM/YYYY') AS "Fecha de Entrada", 
       COUNT(DISTINCT r.id) AS "Cantidad de Reservas"
FROM Reservas r
JOIN Habitaciones h ON h.id_reserva = r.id
WHERE h.hotel = :P11_ID_HOTEL
  AND r.fecha_llegada BETWEEN TO_DATE(:P11_FECHA_INI, 'DD/MM/YYYY') 
                          AND TO_DATE(:P11_FECHA_FIN, 'DD/MM/YYYY')
GROUP BY r.fecha_llegada
ORDER BY r.fecha_llegada ASC;


--RFC 3
SELECT hot.nombre AS "Hotel", 
       COUNT(r.id) AS "Total Reservas Activas",
       SUM(r.personas_adultas) AS "Adultos",
       SUM(NVL(r.menores_3_anios, 0)) AS "Niños < 3 años",
       SUM(r.personas_adultas + NVL(r.menores_3_anios, 0)) AS "Total Personas"
FROM Reservas r
JOIN Habitaciones h ON h.id_reserva = r.id
JOIN Hoteles hot ON h.hotel = hot.id
WHERE hot.id = :P12_ID_HOTEL
  AND TO_DATE(:P12_FECHA_CONSULTA, 'DD/MM/YYYY') BETWEEN r.fecha_llegada AND r.fecha_salida
GROUP BY hot.nombre;


-- RFC 4
SELECT c.nombre AS "Ciudad", 
       hot.nombre AS "Hotel", 
       r.precio_total AS "Ingresos"
FROM Reservas r
JOIN Habitaciones h ON h.id_reserva = r.id
JOIN Hoteles hot ON h.hotel = hot.id
JOIN Ciudades c ON hot.ciudad = c.id
WHERE EXTRACT(YEAR FROM r.fecha_llegada) = :P13_ANIO;



-- RFC 5 - Servicios
SELECT s.nombre AS "Servicio", 
       COUNT(*) AS "Veces Solicitado"
FROM Servicios s
JOIN Habitaciones h ON s.numero_habitacion = h.numero
JOIN Reservas r ON h.id_reserva = r.id
WHERE h.hotel = :P14_ID_HOTEL
  AND r.fecha_llegada BETWEEN TO_DATE(:P14_FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:P14_FECHA_FIN, 'DD/MM/YYYY')
GROUP BY s.nombre
ORDER BY "Veces Solicitado" DESC;

-- Habitaciones
SELECT th.nombre AS "Tipo de Habitación", 
       COUNT(*) AS "Total Reservas"
FROM Reservas r
JOIN Habitaciones h ON h.id_reserva = r.id
JOIN TiposHabitaciones th ON h.tipo_habitacion = th.id
WHERE h.hotel = :P14_ID_HOTEL
  AND r.fecha_llegada BETWEEN TO_DATE(:P14_FECHA_INI, 'DD/MM/YYYY') AND TO_DATE(:P14_FECHA_FIN, 'DD/MM/YYYY')
GROUP BY th.nombre
ORDER BY "Total Reservas" DESC;
