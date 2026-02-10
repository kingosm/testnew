import { Button } from "@/components/ui/button";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useLanguage } from "@/contexts/LanguageContext";
import { Languages } from "lucide-react";

export function LanguageSwitcher() {
    const { language, setLanguage, isRTL } = useLanguage();

    const languages = [
        { code: 'en', label: 'English', native: 'EN', short: 'EN', dir: 'ltr' },
        { code: 'ku', label: 'Kurdish', native: 'KU', short: 'KU', dir: 'ltr' },
        { code: 'ar', label: 'Arabic', native: 'AR', short: 'AR', dir: 'ltr' },
    ] as const;

    const currentLang = languages.find(l => l.code === language);

    return (
        <DropdownMenu>
            <DropdownMenuTrigger asChild>
                <Button
                    variant="ghost"
                    size="sm"
                    className="rounded-full font-bold text-xs h-10 px-3 border border-white/10 hover:bg-white/5 gap-1.5"
                    aria-label="Change language"
                >
                    <Languages className="h-4 w-4" />
                    <span>{currentLang?.short}</span>
                </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="w-[140px] min-w-[140px] p-1">
                {languages.map((lang) => (
                    <DropdownMenuItem
                        key={lang.code}
                        onClick={() => setLanguage(lang.code)}
                        className={`justify-between font-medium text-sm cursor-pointer ${language === lang.code ? "bg-accent/50" : ""
                            }`}
                        dir={lang.dir}
                    >
                        <span>{lang.native}</span>
                        {language === lang.code && (
                            <span className="text-xs opacity-60">✓</span>
                        )}
                    </DropdownMenuItem>
                ))}
            </DropdownMenuContent>
        </DropdownMenu>
    );
}
