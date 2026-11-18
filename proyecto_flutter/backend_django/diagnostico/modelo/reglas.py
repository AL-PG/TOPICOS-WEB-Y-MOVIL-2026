from collections.abc import Mapping


_PRIORIDAD_POR_DIAGNOSTICO = {
    "basico": "baja",
    "intermedio": "media",
    "avanzado": "alta",
}

_OBSERVACIONES = {
    "contacto_liquido": "contacto con líquidos",
    "sobrecalentamiento": "sobrecalentamiento anormal",
    "bateria_hinchada": "hinchazón de la batería",
}


def _normalizar_observacion(valor: object, campo: str) -> bool | None:
    if valor is None or isinstance(valor, bool):
        return valor

    if isinstance(valor, str):
        opciones = {"si": True, "sí": True, "no": False, "no_sabe": None}
        texto = valor.strip().casefold()
        if texto in opciones:
            return opciones[texto]

    raise ValueError(
        f"'{campo}' debe ser true, false, null, 'si', 'no' o 'no_sabe'."
    )


def aplicar_reglas(
    respuestas: Mapping[str, object], diagnostico_modelo: str
) -> dict[str, object]:

    if not isinstance(respuestas, Mapping):
        raise TypeError("Las respuestas deben ser un diccionario.")

    if (
        not isinstance(diagnostico_modelo, str)
        or diagnostico_modelo not in _PRIORIDAD_POR_DIAGNOSTICO
    ):
        raise ValueError(
            "El diagnóstico original debe ser 'basico', 'intermedio' o 'avanzado'."
        )

    observaciones = {
        campo: _normalizar_observacion(respuestas.get(campo), campo)
        for campo in _OBSERVACIONES
    }
    diagnostico = diagnostico_modelo
    prioridad = _PRIORIDAD_POR_DIAGNOSTICO[diagnostico_modelo]
    motivos = []

    if observaciones["bateria_hinchada"] or observaciones["sobrecalentamiento"]:
        diagnostico = "avanzado"
        prioridad = "critica"
        if observaciones["bateria_hinchada"]:
            motivos.append(
                "La batería hinchada requiere diagnóstico avanzado y prioridad crítica."
            )
        if observaciones["sobrecalentamiento"]:
            motivos.append(
                "El sobrecalentamiento anormal requiere diagnóstico avanzado "
                "y prioridad crítica."
            )
    elif observaciones["contacto_liquido"]:
        diagnostico = "avanzado"
        prioridad = "alta"
        motivos.append(
            "El contacto con líquidos requiere diagnóstico avanzado y prioridad alta."
        )
    else:
        desconocidas = [
            descripcion
            for campo, descripcion in _OBSERVACIONES.items()
            if observaciones[campo] is None
        ]
        if desconocidas:
            prioridad = "alta"
            motivos.extend(
                f"Falta confirmar {descripcion}; se asigna prioridad alta "
                "para revisión inicial."
                for descripcion in desconocidas
            )

    return {
        "diagnostico_modelo": diagnostico_modelo,
        "diagnostico": diagnostico,
        "prioridad": prioridad,
        "cambio_reglas": diagnostico != diagnostico_modelo,
        "motivos": motivos,
    }
