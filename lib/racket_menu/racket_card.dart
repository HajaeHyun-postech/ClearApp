
import 'package:flutter/material.dart';

class RacketCard {
  final String id;
  final String name;
  final String location;
  final String distance;
  final String gravity;
  final String description;
  final String image;
  final String backgroundImg;
  final bool isavailable;

  RacketCard({
    this.id,
    this.name,
    this.location,
    this.distance,
    this.gravity,
    this.description,
    this.image,
    this.backgroundImg,
    this.isavailable,
  });
}

List<RacketCard> racketcardlist = [
  RacketCard(
    id: "1",
    name: "YONEX",
    location: "ASTROX 5FX",
    distance: "227.9m Km",
    gravity: "3.711 m/s ",
    description: "Mars WOW",
    image: 'assets/logo/IMG_2042_2.png',
    backgroundImg: "assets/img/marsBG.jpg",
    isavailable: true,
  ),
  RacketCard(
    id: "2",
    name: "VICTOR",
    location: "ARS-70FNA",
    distance: "54.6m Km",
    gravity: "11.15 m/s ",
    description: "Neptune WOW",
    image: "assets/logo/IMG_2031_2.png",
    backgroundImg: "assets/img/neptuneBG.jpg",
    isavailable: true,
  ),
  RacketCard(
    id: "3",
    name: "VICTOR",
    location: "TK-70F",
    distance: "54.6m Km",
    gravity: "1.622 m/s ",
    description: "Moon WOW",
    image: "assets/logo/IMG_2031_2.png",
    backgroundImg: "assets/img/MoonBG.jpg",
    isavailable: false,
  ),
  RacketCard(
    id: "4",
    name: "Earth",
    location: "VOLTRIC LD200",
    distance: "54.6m Km",
    gravity: "9.807 m/s ",
    description: "Earth WOW",
    image: 'assets/logo/IMG_2042_2.png',
    backgroundImg: "assets/img/EarthBG.jpg",
    isavailable: false,
  ),
  RacketCard(
    id: "5",
    name: "Mercury",
    location: "NANORAY 800",
    distance: "54.6m Km",
    gravity: "3.7 m/s ",
    description: "Mercury WOW",
    image: "assets/logo/IMG_2042_2.png",
    backgroundImg: "assets/img/MercuryBG.jpg",
    isavailable: false,
  ),
  RacketCard(
    id: "6",
    name: "Mercury",
    location: "NANORAY 300",
    distance: "54.6m Km",
    gravity: "3.7 m/s ",
    description: "Mercury WOW",
    image: "assets/logo/IMG_2042_2.png",
    backgroundImg: "assets/img/MercuryBG.jpg",
    isavailable: true,
  ),
  RacketCard(
    id: "7",
    name: "Mercury",
    location: "VARS-80X C",
    distance: "54.6m Km",
    gravity: "3.7 m/s ",
    description: "Mercury WOW",
    image: "assets/logo/IMG_2031_2.png",
    backgroundImg: "assets/img/MercuryBG.jpg",
    isavailable: false,
  ),
  RacketCard(
    id: "8",
    name: "Mercury",
    location: "ASTROX 100 ZX",
    distance: "54.6m Km",
    gravity: "3.7 m/s ",
    description: "Mercury WOW",
    image: "assets/logo/IMG_2042_2.png",
    backgroundImg: "assets/img/MercuryBG.jpg",
    isavailable: false,
  ),RacketCard(
    id: "9",
    name: "Mercury",
    location: "AURASPEED 90S",
    distance: "54.6m Km",
    gravity: "3.7 m/s ",
    description: "Mercury WOW",
    image: "assets/logo/IMG_2031_2.png",
    backgroundImg: "assets/img/MercuryBG.jpg",
    isavailable: true,
  ),
  RacketCard(
    id: "10",
    name: "Mercury",
    location: "HYPERNANO 70",
    distance: "54.6m Km",
    gravity: "3.7 m/s ",
    description: "Mercury WOW",
    image: "assets/logo/IMG_2031_2.png",
    backgroundImg: "assets/img/MercuryBG.jpg",
    isavailable: true,
  ),

];