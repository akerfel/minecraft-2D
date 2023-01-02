import java.awt.Color;
import processing.core.*;
import java.io.Serializable;

Block generateBlockObject(String name) {
    switch (name) {
    case "dirt":
        return new Dirt();
    case "grass":
        return new Grass();
    case "leaves":
        return new Leaves();
    case "planks":
        return new Planks();
    case "sand":
        return new Sand();
    case "stone":
        return new Stone();
    case "water":
        return new Water();
    case "wood":
        return new Wood();
    }
    return new Grass();
}

public class Dirt extends Block {
    public Dirt() {
        super("dirt", new Color(151, 109, 77), false, "shovel", true);
    }

    public String toString() {
        return "dirt";
    }
}

public class Grass extends Block {
    public Grass() {
        super("grass", new Color(127, 178, 56), false, "shovel", false);
    }

    public String toString() {
        return "grass";
    }
}

public class Leaves extends Block {
    public Leaves() {
        super("leaves", new Color(0, 124, 0), true, "axe", true);
        this.hardness = 0.2;
    }

    public String toString() {
        return "leaves";
    }
}

public class Planks extends Block {
    public Planks() {
        super("planks", new Color(194, 155, 115), true, "axe", true);
    }

    public String toString() {
        return "planks";
    }
}

public class Sand extends Block {
    public Sand() {
        super("sand", new Color(247, 233, 163), false, "shovel", true);
    }

    public String toString() {
        return "sand";
    }
}

public class Stone extends Block {
    public Stone() {
        super("stone", new Color(112, 112, 112), true, "pick", true);
    }

    public String toString() {
        return "stone";
    }
}

public class Water extends Block {
    public Water() {
        super("water", new Color(64, 64, 255), false, "nothing", false);
        hardness = 100000;
    }

    public String toString() {
        return "water";
    }
}

public class Wood extends Block {
    public Wood() {
        super("wood", new Color(174, 125, 90), true, "axe", true);
    }

    public String toString() {
        return "wood";
    }
}
