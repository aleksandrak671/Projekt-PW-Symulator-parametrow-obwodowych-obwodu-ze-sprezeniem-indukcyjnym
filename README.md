# Symulator obwodu RLC ze sprzężeniem indukcyjnym

**Projekt zaliczeniowy z przedmiotu Metody Numeryczne.**

## O projekcie

Celem projektu było stworzenie symulatora obwodu elektrycznego RLC z uwzględnieniem sprzężenia transformatorowego w stanie nieustalonym. Projekt łączy zagadnienia inżynierskie (teoria obwodów) z implementacją algorytmów numerycznych w środowisku MATLAB.

Symulator analizuje zarówno wariant **liniowy** (stała indukcyjność wzajemna M), jak i **nieliniowy** (indukcyjność M zależna od napięcia, wyznaczana z charakterystyki pomiarowej).

## Zastosowane metody numeryczne

Projekt został podzielony na 4 główne części, w których zaimplementowano i przetestowano następujące metody:

### 1. Rozwiązywanie równań różniczkowych (ODE)
* **Metoda Eulera** (rzędu I)
* **Ulepszona metoda Eulera** (metoda Heuna, rzędu II) – wybrana jako główny solver ze względu na lepszą stabilność.

### 2. Interpolacja i aproksymacja (Nieliniowość)
Analiza wpływu doboru metody przybliżania charakterystyki M(u) na stabilność symulacji (badanie efektu Rungego):
* Interpolacja wielomianowa (metoda Newtona)
* Interpolacja funkcjami sklejanymi (Spline 3. stopnia)
* Aproksymacja wielomianowa (stopnia 3 i 5)

### 3. Całkowanie numeryczne
Obliczanie energii wydzielanej w układzie:
* Metoda złożonych prostokątów
* Metoda złożonych parabol (wzór Simpsona)

### 4. Wyznaczanie miejsc zerowych (Optymalizacja)
Poszukiwanie częstotliwości wymuszenia dla zadanej mocy P:
* Metoda bisekcji
* Metoda siecznych
* Metoda Quasi-Newtona (z numerycznym wyznaczaniem pochodnej i doborem kroku różniczkowania df)

## Struktura repozytorium

Kod został podzielony na katalogi odpowiadające kolejnym etapom projektu:

* **część 1/** – Symulacja obwodu liniowego. Porównanie metod Eulera.
* **część 2/** – Symulacja obwodu nieliniowego. Implementacja metod interpolacji i aproksymacji.
* **część 3/** – Obliczanie energii (całkowanie) dla różnych kroków czasowych.
* **część 4/** – Wyznaczanie parametrów sterujących (częstotliwości) metodami iteracyjnymi.

## Weryfikacja

Poprawność działania symulatora została zweryfikowana poprzez:
* Porównanie wyników z rozwiązaniem analitycznym dla uproszczonego modelu.
* Porównanie przebiegów z zewnętrznym oprogramowaniem symulacyjnym (Qucs).
* Analizę stabilności rozwiązań dla różnych kroków czasowych.

---
*Projekt wykonany na zaliczenie przedmiotu Metody Numeryczne.*
