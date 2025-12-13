class ExerciseSeedData {
  final String name;
  final String targetMuscle;
  final String bodyPart;
  final String category;
  final String instructions;
  final String youtubeUrl;

  const ExerciseSeedData({
    required this.name,
    required this.targetMuscle,
    required this.bodyPart,
    required this.category,
    required this.instructions,
    required this.youtubeUrl,
  });
}

const List<ExerciseSeedData> masterExercises = [
  // --- CHEST (Jeff Nippard & Davis Diley) ---
  ExerciseSeedData(
    name: 'Barbell Bench Press',
    targetMuscle: 'Mid Chest',
    bodyPart: 'Chest',
    category: 'barbell',
    instructions:
        '1. Arch back slightly, retract scapula.\n2. Grip slightly wider than shoulder width.\n3. Lower bar to nipple line (touch shirt).\n4. Press up and slightly back towards face (J-Curve path).',
    youtubeUrl: 'https://youtu.be/hWbUlkb5Ms4',
  ),
  ExerciseSeedData(
    name: 'Incline Dumbbell Press',
    targetMuscle: 'Upper Chest',
    bodyPart: 'Chest',
    category: 'dumbbell',
    instructions:
        '1. Set bench to 30° (lower than you think).\n2. Tuck elbows slightly (45° angle).\n3. Drive biceps towards clavicle.\n4. Do not clang dumbbells at the top.',
    youtubeUrl: 'https://youtu.be/2yjwXTZQDDI',
  ),

  // --- BACK (Renaissance Periodization & Jeff) ---
  ExerciseSeedData(
    name: 'Lat Pulldown',
    targetMuscle: 'Lats',
    bodyPart: 'Back',
    category: 'machine',
    instructions:
        '1. Thumbless grip, slightly wider than shoulder.\n2. Drive elbows DOWN, not back.\n3. Keep chest up, slight lean back.\n4. Control the eccentric (way up) for 2 seconds.',
    youtubeUrl: 'https://youtu.be/-c_TPoSUYuk',
  ),
  ExerciseSeedData(
    name: 'DB Row (RP Style)',
    targetMuscle: 'Lats',
    bodyPart: 'Back',
    category: 'dumbbell',
    instructions:
        '1. Use a bench for support.\n2. Pull elbow towards HIP, not ceiling.\n3. Stretch arm forward at the bottom (protract).\n4. Keep torso parallel to floor.',
    youtubeUrl: 'https://youtu.be/JZhNM0a51wc',
  ),

  // --- LEGS (Davis Diley & Jeff) ---
  ExerciseSeedData(
    name: 'Barbell Squat',
    targetMuscle: 'Quads/Glutes',
    bodyPart: 'Legs',
    category: 'barbell',
    instructions:
        '1. Bar over mid-foot.\n2. Brace core (360° expansion).\n3. Break at knees and hips simultaneously.\n4. Depth: Hip crease below knee top.',
    youtubeUrl: 'https://youtu.be/ultWZbGWL5c',
  ),

  // --- SHOULDERS (Jeremy Ethier/Jeff) ---
  ExerciseSeedData(
    name: 'Overhead Press (OHP)',
    targetMuscle: 'Front Delt',
    bodyPart: 'Shoulders',
    category: 'barbell',
    instructions:
        '1. Squeeze glutes to protect lower back.\n2. Head back, clear path for bar.\n3. Press vertically, lock out overhead.\n4. Shrug at the top.',
    youtubeUrl: 'https://youtu.be/6b07Yq4DyLs',
  ),
];
