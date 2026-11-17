import uuid
from decimal import Decimal

from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models


class Pedido(models.Model):
    folio = models.UUIDField(default=uuid.uuid4, unique=True, editable=False)
    fecha = models.DateTimeField(auto_now_add=True)
    respuestas = models.JSONField()


class Resultado(models.Model):
    class NivelDiagnostico(models.TextChoices):
        BASICO = "basico", "Básico"
        INTERMEDIO = "intermedio", "Intermedio"
        AVANZADO = "avanzado", "Avanzado"

    class Prioridad(models.TextChoices):
        CRITICA = "critica", "Crítica"
        ALTA = "alta", "Alta"
        MEDIA = "media", "Media"
        BAJA = "baja", "Baja"

    pedido = models.OneToOneField(
        Pedido,
        on_delete=models.CASCADE,
        related_name="resultado",
    )
    diagnostico_original = models.CharField(
        max_length=10,
        choices=NivelDiagnostico,
    )
    diagnostico = models.CharField(
        max_length=10,
        choices=NivelDiagnostico,
    )
    confianza = models.DecimalField(
        max_digits=5,
        decimal_places=4,
        validators=[
            MinValueValidator(Decimal("0")),
            MaxValueValidator(Decimal("1")),
        ],
    )
    equipo = models.CharField(max_length=200)
    prioridad = models.CharField(max_length=7, choices=Prioridad)
    ranking = models.JSONField(default=list, blank=True)
    cambio_reglas = models.BooleanField(default=False)
    motivos = models.JSONField(default=list, blank=True)

    class Meta:
        constraints = [
            models.CheckConstraint(
                condition=models.Q(confianza__gte=0, confianza__lte=1),
                name="resultado_confianza_entre_0_y_1",
            ),
        ]
