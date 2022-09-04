#pragma once

#include <QObject>

#define AUTO_PROPERTY(TYPE, name) \
Q_PROPERTY(TYPE name READ name WRITE name NOTIFY name##Changed) \
public: \
    TYPE name() const { return m_##name; } \
    void name(TYPE const& value) \
    { \
        if (m_##name == value) return; \
        m_##name = value; \
        emit name##Changed(m_##name); \
    } \
    Q_SIGNAL void name##Changed(TYPE const& value); \
private: \
    TYPE m_##name { };

#define READONLY_PROPERTY(TYPE, name) \
Q_PROPERTY(TYPE name READ name CONSTANT) \
public: \
    TYPE name() const { return m_##name; } \
private: \
    void name(TYPE const& value) { m_##name = value; } \
    TYPE m_##name { };

#define READONLY_PROPERTY_WITH_SIGNAL(TYPE, name) \
Q_PROPERTY(TYPE name READ name NOTIFY name##Changed) \
public: \
    TYPE name() const { return m_##name; } \
    Q_SIGNAL void name##Changed(TYPE const& value); \
private: \
    void name(TYPE const& value) { m_##name = value; } \
    TYPE m_##name { };
