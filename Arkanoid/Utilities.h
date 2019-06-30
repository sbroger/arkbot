#pragma once

#include <algorithm>
#include <filesystem>
#include <fstream>
#include <locale>
#include <string>
#include <vector>

namespace MathUtil
{
    template<class T>
    T Clamp(T& val, const T& firstBound, const T& secondBound)
    {
        const auto oldVal = val;
        if (firstBound < secondBound)
        {
            val = std::max(val, firstBound);
            val = std::min(val, secondBound);
        }
        else
        {
            val = std::max(val, secondBound);
            val = std::min(val, firstBound);
        }

        return val - oldVal;
    }

    template<class T>
    bool PointInRect(const T& pointX, const T& pointY, const T& rectLeft, const T& rectTop, const T& rectWidth, const T& rectHeight)
    {
        return (pointX >= rectLeft && pointX <= rectLeft + rectWidth)
               && (pointY >= rectTop && pointY <= rectTop + rectHeight);
    }
}

class StringUtil
{
public:
    static std::vector<std::string> Split(const std::string& text, const char delim)
    {
        std::vector<std::string> parts;
        std::size_t start = 0;
        std::size_t end;

        while ((end = text.find(delim, start)) != std::string::npos)
        {
            parts.emplace_back(text.substr(start, end - start));
            start = end + 1;
        }

        parts.emplace_back(text.substr(start));
        return parts;
    }
};

class FileUtil
{
public:
    static void SetWorkingDir(std::wstring&& dir)
    {
        workingDir = dir;
    }

    static std::wstring WorkingDir()
    {
        return (!workingDir.empty() ? workingDir : std::filesystem::current_path().c_str()) + LR"(\)";
    }

    static std::wstring UnitTestDir()
    {
        return WorkingDir() + LR"(TestData\)";
    }

    static std::wstring ResultsDir()
    {
        return WorkingDir() + std::wstring(LR"(Results\)");
    }

    static std::wstring PartialsDir()
    {
        return FileUtil::ResultsDir() + LR"(partials\)";
    }

    static std::wstring ScoreVarDir()
    {
        return FileUtil::ResultsDir() + LR"(scoreVariants\)";
    }

    static void ClearFile(const std::wstring& filename)
    {
        std::ofstream outFile;
        outFile.open(filename, std::ofstream::out | std::ofstream::trunc);
        outFile.close();
    }

    static void AppendToFile(const std::wstring& filename, const std::string& text)
    {
        std::ofstream outFile;
        outFile.open(filename, std::ofstream::out | std::ofstream::app);
        outFile << text.c_str() << std::endl;
        outFile.close();
    }

    static void AppendToFile(const std::wstring& filename, const std::wstring& text)
    {
        std::wofstream outFile;
        outFile.open(filename, std::wofstream::out | std::wofstream::app);
        outFile << text.c_str() << std::endl;
        outFile.close();
    }

private:
    static std::wstring workingDir;
};

class Log
{
public:
    static void Clear()
    {
        FileUtil::ClearFile(FileUtil::ResultsDir() + L"Output.txt");
    }

    static void Write(const std::string& text)
    {
        FileUtil::AppendToFile(FileUtil::ResultsDir() + L"Output.txt", text);
    }

    static void Write(const std::wstring& text)
    {
        FileUtil::AppendToFile(FileUtil::ResultsDir() + L"Output.txt", text);
    }
};